require "rails_helper"

RSpec.describe "Taskモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    it "タイトル、期限がある場合、有効である" do
      expect(FactoryBot.build(:task)).to be_valid
    end
    
    it "タイトルがない場合、無効である" do
      expect(FactoryBot.build(:task, title: nil)).to_not be_valid
    end
    
    it "期限がない場合、無効である" do
      expect(FactoryBot.build(:task, due: nil)).to_not be_valid
    end
    
    it "新規作成時のみ、期限が過去の日時の場合、無効である" do
      expect(FactoryBot.build(:task, due: Time.now - 1.day)).to_not be_valid
    end
  end
  
  describe "アソシエーションのテスト" do
    it "UserモデルとN:1となっている" do
      expect(Task.reflect_on_association(:user).macro).to eq :belongs_to
    end
  end
end
