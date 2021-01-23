require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  
  describe 'バリデーションのテスト' do
    it "ニックネーム(2〜10文字以内)、メール、パスワード(6文字以上)がある場合、有効である" do
      expect(FactoryBot.build(:user)).to be_valid
    end
    
    it "ニックネームがない場合、無効である" do
      expect(FactoryBot.build(:user, nickname: nil)).to_not be_valid
    end
    
    it "ニックネームが2文字未満の場合、無効である" do
      expect(FactoryBot.build(:user, nickname: '1')).to_not be_valid
    end
    
    it "ニックネームが10文字を超える場合、無効である" do
      expect(FactoryBot.build(:user, nickname: 'これは11文字の名前。')).to_not be_valid
    end
    
    it "メールアドレスがない場合、無効である" do
      expect(FactoryBot.build(:user, email: nil)).to_not be_valid
    end
    
    it "重複したメールアドレスの場合、無効である" do
      user1 = FactoryBot.create(:user, email: 'usertest@example.com')
      expect(FactoryBot.build(:user, email: user1.email)).to_not be_valid
    end
    
    it "パスワードがない場合、無効である" do
      expect(FactoryBot.build(:user, password: nil)).to_not be_valid
    end
    
    it "パスワードが6文字未満の場合、無効である" do
      expect(FactoryBot.build(:user, password: '12345')).to_not be_valid
    end
    
    it "password_confirmationとpasswordが異なる場合、登録できない" do 
      expect(FactoryBot.build(:user, password: "password", password_confirmation: "passwaad")).to_not be_valid 
    end
  end
  
  describe 'アソシエーションのテスト' do
    it 'Learningモデルと1:Nとなっている' do
      expect(User.reflect_on_association(:learnings).macro).to eq :has_many
    end
    
    it 'Taskモデルと1:Nとなっている' do
      expect(User.reflect_on_association(:tasks).macro).to eq :has_many
    end
    
    it 'LearningCommentモデルと1:Nとなっている' do
      expect(User.reflect_on_association(:learning_comments).macro).to eq :has_many
    end
  end
end
