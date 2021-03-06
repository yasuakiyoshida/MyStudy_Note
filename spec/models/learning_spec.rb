require "rails_helper"

RSpec.describe "Learningモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    it "タイトル、学習日、学習時間がある場合、有効である" do
      expect(FactoryBot.build(:learning)).to be_valid
    end

    it "タイトルがない場合、無効である" do
      expect(FactoryBot.build(:learning, title: nil)).not_to be_valid
    end

    it "タイトルが50文字を超える場合、無効である" do
      expect(FactoryBot.build(:learning, title: "あ" * 51)).not_to be_valid
    end

    it "学習日がない場合、無効である" do
      expect(FactoryBot.build(:learning, date: nil)).not_to be_valid
    end

    it "学習日が未来の日付の場合、無効である" do
      expect(FactoryBot.build(:learning, date: Date.today + 1.day)).not_to be_valid
    end

    it "学習時間がない場合、無効である" do
      expect(FactoryBot.build(:learning, time: nil)).not_to be_valid
    end

    it "学習時間が0時間の場合、無効である" do
      expect(FactoryBot.build(:learning, time: 0)).not_to be_valid
    end

    it "学習時間が24時間を超える場合、無効である" do
      expect(FactoryBot.build(:learning, time: 24.1)).not_to be_valid
    end

    it "学習時間が整数か浮動少数以外の場合、無効である" do
      expect(FactoryBot.build(:learning, time: "いち")).not_to be_valid
    end

    it "１日の学習時間の合計が24時間を超える場合、無効である" do
      learning1 = FactoryBot.create(:learning, time: 10)
      expect(FactoryBot.build(:learning, time: 15 + learning1.time)).not_to be_valid
    end
  end

  describe "アソシエーションのテスト" do
    it "UserモデルとN:1となっている" do
      expect(Learning.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it "LearningCommentモデルと1:Nとなっている" do
      expect(Learning.reflect_on_association(:learning_comments).macro).to eq :has_many
    end

    it "Favoriteモデルと1:Nとなっている" do
      expect(Learning.reflect_on_association(:favorites).macro).to eq :has_many
    end
  end
end
