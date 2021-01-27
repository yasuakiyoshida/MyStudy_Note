require "rails_helper"

RSpec.describe Admins::UsersController, type: :request do
  let(:admin) { create(:admin) }

  describe "GET #indexのテスト" do
    context "ログイン済みの場合" do
      before do
        create :alice
        create :bob
        sign_in admin
        get admins_users_url
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 200
      end
      it "ユーザー名が表示されること" do
        expect(response.body).to include "Alice"
        expect(response.body).to include "Bob"
      end
    end

    context "ログインしていない場合" do
      before do
        get admins_users_url
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
    let(:alice) { create :alice }
    context "ログイン済みの場合" do
      before do
        sign_in admin
        get admins_user_url alice.id
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 200
      end
      it "ユーザー名と自己紹介が表示されること" do
        expect(response.body).to include "Alice"
        expect(response.body).to include "Aliceです。よろしくお願いします。"
      end
    end

    context "ログインしていない場合" do
      before do
        get admins_user_url alice.id
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
    let(:alice) { create :alice }
    context "ログイン済みの場合" do
      before do
        sign_in admin
        get edit_admins_user_url alice.id
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 200
      end
      it "ユーザー名と自己紹介が表示されること" do
        expect(response.body).to include "Alice"
        expect(response.body).to include "Aliceです。よろしくお願いします。"
      end
    end

    context "ログインしていない場合" do
      before do
        get edit_admins_user_url alice.id
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
    let(:alice) { create :alice }
    context "パラメータが妥当な場合" do
      before do
        sign_in admin
      end
      
      it "リクエストが成功すること" do
        patch admins_user_url alice, params: { user: attributes_for(:bob) }
        expect(response.status).to eq 302
      end
      it "ユーザー名が更新されること" do
        expect do
          patch admins_user_url alice, params: { user: attributes_for(:bob) }
        end.to change { User.find(alice.id).nickname }.from("Alice").to("Bob")
      end
      it "更新したユーザー詳細ページにリダイレクトされること" do
        patch admins_user_url alice, params: { user: attributes_for(:bob) }
        expect(response).to redirect_to(admins_user_url alice)
      end
    end

    context "パラメータが不正な場合" do
      before do
        sign_in admin
      end
      
      it "リクエストが成功すること" do
        patch admins_user_url alice, params: { user: attributes_for(:user, nickname: nil) }
        expect(response.status).to eq 200
      end
      it "ユーザー名が更新されないこと" do
        expect do
          patch admins_user_url alice, params: { user: attributes_for(:user, nickname: nil) }
        end.to_not change(User.find(alice.id), :nickname)
      end
      it "エラーが表示されること" do
        patch admins_user_url alice, params: { user: attributes_for(:user, nickname: nil) }
        expect(response.body).to include "ニックネームを入力してください"
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { create(:user) }
    before do
      sign_in admin
    end
    
    it "リクエストが成功すること" do
      delete admins_user_url user
      expect(response.status).to eq 302
    end
    it "ユーザーが削除されること" do
      expect do
        delete admins_user_url user
      end.to change(User, :count).by(-1)
    end
    it "ユーザー一覧ページにリダイレクトされること" do
      delete admins_user_url user
      expect(response).to redirect_to admins_users_url
    end
  end
end
