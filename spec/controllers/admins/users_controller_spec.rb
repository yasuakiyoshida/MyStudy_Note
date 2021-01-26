require "rails_helper"

RSpec.describe Admins::UsersController, type: :controller do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user) }

  describe "GET #indexのテスト" do
    context "ログイン済みの場合" do
      before do
        sign_in admin
        get :index
      end

      it "ユーザー一覧ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "ユーザー一覧ページが描画されること" do
        expect(response).to render_template :index
      end
      it "@usersというインスタンス変数が正しく定義されていること" do
        expect(assigns(:users)).to match_array [user]
      end
    end

    context "ログインしていない場合" do
      before do
        get :index
      end

      it "ユーザー一覧ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "管理者ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_admin_session_path
      end
    end
  end

  describe "GET #showのテスト" do
    context "ログイン済みの場合" do
      before do
        sign_in admin
        get :show, params: { id: user.id }
      end

      it "ユーザー詳細ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "ユーザー詳細ページが描画されること" do
        expect(response).to render_template :show
      end
      it "@userというインスタンス変数が正しく定義されていること" do
        expect(assigns(:user)).to eq user
      end
    end

    context "ログインしていない場合" do
      before do
        get :show, params: { id: user.id }
      end

      it "ユーザー一覧ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "管理者ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_admin_session_path
      end
    end
  end

  describe "GET #editのテスト" do
    context "ログイン済みの場合" do
      before do
        sign_in admin
        get :edit, params: { id: user.id }
      end

      it "ユーザー編集ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "ユーザー編集ページが描画されること" do
        expect(response).to render_template :edit
      end
      it "@userというインスタンス変数が正しく定義されていること" do
        expect(assigns(:user)).to eq user
      end
    end

    context "ログインしていない場合" do
      before do
        get :edit, params: { id: user.id }
      end

      it "ユーザー編集ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "管理者ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_admin_session_path
      end
    end
  end

  describe "PATCH #updateのテスト" do
    context "パラメータが妥当な場合" do
      before do
        sign_in admin
        user_params = { nickname: "Alice" }
        patch :update, params: { id: user.id, user: user_params }
      end

      it "ユーザー情報が更新されること" do
        expect(user.reload.nickname).to eq "Alice"
      end
      it "更新後、編集したユーザー詳細ページにリダイレクトされること" do
        expect(response).to redirect_to admins_user_path(user)
      end
      it "@userというインスタンス変数が正しく定義されていること" do
        expect(assigns(:user)).to eq user
      end
    end

    context "パラメータが不正な場合" do
      before do
        sign_in admin
        user_params = { nickname: nil }
        patch :update, params: { id: user.id, user: user_params }
      end

      it "ユーザー情報が更新されないこと" do
        expect(user.reload.nickname).to eq "ユーザー"
      end
      it "editテンプレートが表示されること" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroyのテスト" do
    before do
      sign_in admin
    end

    it "ユーザーが削除されること" do
      expect do
        delete :destroy, params: { id: user }
      end.to change(User, :count).by(-1)
    end
    it "削除後、ユーザー一覧ページにリダイレクトされること" do
      delete :destroy, params: { id: user }
      expect(response).to redirect_to admins_users_path
    end
  end
end
