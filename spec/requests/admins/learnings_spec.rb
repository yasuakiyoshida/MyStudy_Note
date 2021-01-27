require "rails_helper"

RSpec.describe Admins::LearningsController, type: :request do
  let(:admin) { create(:admin) }

  describe "GET #index" do
    context "ログイン済みの場合" do
      before do
        create :learning_english
        create :learning_math
        sign_in admin
        get admins_learnings_url
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 200
      end
      it "学習記録のタイトルが表示されること" do
        expect(response.body).to include "英語"
        expect(response.body).to include "数学"
      end
    end

    context "ログインしていない場合" do
      before do
        get admins_learnings_url
      end

      it "リクエストが失敗すること" do
        expect(response.status).to eq 302
      end
      it "管理者ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_admin_session_url
      end
    end
  end

  describe "GET #show" do
    let(:learning_english) { create :learning_english }
    context "ログイン済みの場合" do
      before do
        sign_in admin
        get admins_learning_url learning_english.id
      end
  
      it "リクエストが成功すること" do
        expect(response.status).to eq 200
      end
      it "学習記録のタイトルと詳細が表示されること" do
        expect(response.body).to include "英語"
        expect(response.body).to include "英語の勉強"
      end
    end
    
    context "ログインしていない場合" do
      before do
        get admins_learning_url learning_english.id
      end
  
      it "リクエストが失敗すること" do
        expect(response.status).to eq 302
      end
      it "管理者ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_admin_session_url
      end
    end
  end

  describe "GET #edit" do
    let(:learning_english) { create :learning_english }
    context "ログイン済みの場合" do
      before do
        sign_in admin
        get edit_admins_learning_url learning_english.id
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 200
      end
      it "学習記録のタイトルと詳細が表示されること" do
        expect(response.body).to include "英語"
        expect(response.body).to include "英語の勉強"
      end
    end

    context "ログインしていない場合" do
      before do
        get edit_admins_learning_url learning_english.id
      end

      it "リクエストが失敗すること" do
        expect(response.status).to eq 302
      end
      it "管理者ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_admin_session_url
      end
    end
  end

  describe "PATCH #update" do
    let(:learning_english) { create :learning_english }
    context "パラメータが妥当な場合" do
      before do
        sign_in admin
      end

      it "リクエストが成功すること" do
        patch admins_learning_url learning_english, params: { learning: attributes_for(:learning_math) }
        expect(response.status).to eq 302
      end
      it "学習記録のタイトルが更新されること" do
        expect do
          patch admins_learning_url learning_english, params: { learning: attributes_for(:learning_math) }
        end.to change { Learning.find(learning_english.id).title }.from("英語").to("数学")
      end
      it "更新した学習記録詳細ページにリダイレクトされること" do
        patch admins_learning_url learning_english, params: { learning: attributes_for(:learning_math) }
        expect(response).to redirect_to(admins_learning_url learning_english)
      end
    end

    context "パラメータが不正な場合" do
      before do
        sign_in admin
      end
      
      it "リクエストが成功すること" do
        patch admins_learning_url learning_english, params: { learning: attributes_for(:learning, title: nil) }
        expect(response.status).to eq 200
      end
      it "学習記録のタイトルが更新されないこと" do
        expect do
          patch admins_learning_url learning_english, params: { learning: attributes_for(:learning, title: nil) }
        end.to_not change(Learning.find(learning_english.id), :title)
      end
      it "エラーが表示されること" do
        patch admins_learning_url learning_english, params: { learning: attributes_for(:learning, title: nil) }
        expect(response.body).to include "タイトルを入力してください"
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:learning) { create(:learning) }
    before do
      sign_in admin
    end
    
    it "リクエストが成功すること" do
      delete admins_learning_url learning
      expect(response.status).to eq 302
    end
    it "学習記録が削除されること" do
      expect do
        delete admins_learning_url learning
      end.to change(Learning, :count).by(-1)
    end
    it "学習記録一覧ページにリダイレクトされること" do
      delete admins_learning_url learning
      expect(response).to redirect_to admins_learnings_url
    end
  end
end
