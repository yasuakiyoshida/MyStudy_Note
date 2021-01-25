require "rails_helper"

RSpec.describe Public::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  
  describe "GET #indexのテスト" do
    context "ログイン済みの場合" do
      before do
        sign_in user
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
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe "GET #showのテスト" do
    before do
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
  
  describe "GET #editのテスト" do
    context "ログイン済みの場合" do
      before do
        sign_in user
        get :edit, params: { id: user.id }
      end
      it "自分のユーザー編集ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "自分のユーザー編集ページが描画されること" do
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
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_path
      end
    end
    
    context "他人のユーザー編集ページの場合" do
      before do
        sign_in user
        get :edit, params: { id: another_user.id }
      end
      it "他人のユーザー編集ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "マイページにリダイレクトされること" do
        expect(response).to redirect_to user_path(user)
      end
    end
  end
  
  describe "PATCH #updateのテスト" do
    context "自分のユーザー情報であり、かつパラメータが妥当な場合" do
      before do
        sign_in user
        user_params = { nickname: "Alice" }
        patch :update, params: { id: user.id, user: user_params }
      end
      it "ユーザー情報が更新されること" do
        expect(user.reload.nickname).to eq "Alice"
      end
      it "更新後、マイページにリダイレクトされること" do
        expect(response).to redirect_to user_path(user)
      end
      it "@userというインスタンス変数が正しく定義されていること" do
        expect(assigns(:user)).to eq user
      end
    end
    
    context "自分のユーザー情報であり、かつパラメータが不正な場合" do
      before do
        sign_in user
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
    
    context "他のユーザーの情報を編集しようとする場合" do
      before do
        sign_in user
        another_user_params = { nickname: "Alice" }
        patch :update, params: { id: another_user.id, user: another_user_params }
      end
      it "ユーザー情報が更新されないこと" do
        expect(another_user.reload.nickname).not_to eq "Alice"
      end
      it "マイページにリダイレクトされること" do
        expect(response).to redirect_to user_path(user)
      end
    end
  end
end
