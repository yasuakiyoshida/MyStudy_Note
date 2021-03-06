class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :learnings, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :learning_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :followings, through: :relationships, source: :followed

  attachment :image

  validates :nickname, presence: true, length: { in: 2..10 }
  validates :email, presence: true, uniqueness: true

  # ユーザーをフォロー
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  # フォロー解除
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  # ユーザーをフォローしているか
  def following?(user)
    followings.include?(user)
  end

  # S3のURL取得
  def image_url
    if image_id?
      "https://mystudynote-img-files-resize.s3-ap-northeast-1.amazonaws.com/store/#{image_id}-thumbnail."
    else
      'https://mystudynote-img-files-resize.s3-ap-northeast-1.amazonaws.com/store/user-no-img.png'
    end
  end
end
