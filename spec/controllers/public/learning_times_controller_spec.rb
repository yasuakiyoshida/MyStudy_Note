require "rails_helper"

RSpec.describe Public::LearningTimesController, type: :controller do
  let(:user) { create(:user) }
  
  describe "GET #indexのテスト" do
    context "ログイン済みの場合" do
      before do
        sign_in user
        get :index, params: { user_id: user.id }
      end
      it "学習時間確認ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "学習時間確認ページが描画されること" do
        expect(response).to render_template :index
      end
      it "@userというインスタンス変数が正しく定義されていること" do
        expect(assigns(:user)).to eq user
      end
    end
    
    context "ログインしていない場合" do
      before do
        get :index, params: { user_id: user.id }
      end
      it "学習時間確認ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
