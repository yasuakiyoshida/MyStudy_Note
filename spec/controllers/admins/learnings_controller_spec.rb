require "rails_helper"

RSpec.describe Admins::LearningsController, type: :controller do
  let(:admin) { create(:admin) }
  let!(:learning) { create(:learning) }

  describe "GET #indexのテスト" do
    context "ログイン済みの場合" do
      before do
        sign_in admin
        get :index
      end

      it "学習記録一覧ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "学習記録一覧ページが描画されること" do
        expect(response).to render_template :index
      end
      it "@learningsというインスタンス変数が正しく定義されていること" do
        expect(assigns(:learnings)).to match_array [learning]
      end
    end

    context "ログインしていない場合" do
      before do
        get :index
      end

      it "学習記録一覧ページへのリクエストは302 リダイレクトとなること" do
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
        get :show, params: { id: learning.id }
      end
  
      it "学習記録詳細ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "学習記録詳細ページが描画されること" do
        expect(response).to render_template :show
      end
      it "@learningというインスタンス変数が正しく定義されていること" do
        expect(assigns(:learning)).to eq learning
      end
    end
    
    context "ログインしていない場合" do
      before do
        get :show, params: { id: learning.id }
      end
  
      it "学習記録詳細ページへのリクエストは302 リダイレクトとなること" do
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
        get :edit, params: { id: learning.id }
      end

      it "学習記録編集ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "学習記録編集ページが描画されること" do
        expect(response).to render_template :edit
      end
      it "@learningというインスタンス変数が正しく定義されていること" do
        expect(assigns(:learning)).to eq learning
      end
    end

    context "ログインしていない場合" do
      before do
        get :edit, params: { id: learning.id }
      end

      it "学習記録編集ページへのリクエストは302 リダイレクトとなること" do
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
        learning_params = { title: "タイトル変更" }
        patch :update, params: { id: learning.id, learning: learning_params }
      end

      it "学習記録が更新されること" do
        expect(learning.reload.title).to eq "タイトル変更"
      end
      it "更新後、更新した学習記録詳細ページにリダイレクトされること" do
        expect(response).to redirect_to admins_learning_path(learning)
      end
      it "@learningというインスタンス変数が正しく定義されていること" do
        expect(assigns(:learning)).to eq learning
      end
    end

    context "パラメータが不正な場合" do
      before do
        sign_in admin
        learning_params = { title: nil }
        patch :update, params: { id: learning.id, learning: learning_params }
      end

      it "学習記録が更新されないこと" do
        expect(learning.reload.title).to eq "学習記録のタイトル"
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

    it "学習記録が削除されること" do
      expect do
        delete :destroy, params: { id: learning }
      end.to change(Learning, :count).by(-1)
    end
    it "削除後、学習記録一覧ページにリダイレクトされること" do
      delete :destroy, params: { id: learning }
      expect(response).to redirect_to admins_learnings_path
    end
  end
end
