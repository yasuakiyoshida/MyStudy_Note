require "rails_helper"

RSpec.describe "LearningCommentモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    
    it "コメントがある場合、有効である" do
      expect(FactoryBot.build(:learning_comment)).to be_valid
    end
    
    it "コメントがない場合、無効である" do
      expect(FactoryBot.build(:learning_comment, comment: nil)).to_not be_valid
    end
  end
  
  describe "アソシエーションのテスト" do
    it "UserモデルとN:1となっている" do
      expect(LearningComment.reflect_on_association(:user).macro).to eq :belongs_to
    end
  end
  
  describe "アソシエーションのテスト" do
    it "LearningモデルとN:1となっている" do
      expect(LearningComment.reflect_on_association(:learning).macro).to eq :belongs_to
    end
  end
end
