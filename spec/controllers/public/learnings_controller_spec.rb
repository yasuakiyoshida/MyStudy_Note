require "rails_helper"

RSpec.describe Public::LearningsController, type: :controller do
  let(:user) { create(:user) }
  let(:learning) { create(:learning, user: user) }
  let(:learnings) { user.learnings }
  let(:another_user) { create(:user) }
  let(:another_learning) { create(:learning, user: another_user) }
  
  describe "GET #newのテスト" do
    context "ログイン済みの場合" do
      before do
        sign_in user
        get :new
      end
      it "学習記録作成ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "学習記録作成ページが描画されること" do
        expect(response).to render_template :new
      end
    end
    
    context "ログインしていない場合" do
      before do
        get :new
      end
      it "学習記録作成ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe "GET #indexのテスト" do
    context "ログイン済みの場合" do
      before do
        sign_in user
        get :index
      end
      it "学習記録一覧ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "学習記録一覧ページが描画されること" do
        expect(response).to render_template :index
      end
      it "@learningsというインスタンス変数が正しく定義されていること" do
        expect(assigns(:learnings)).to eq learnings
      end
    end
    
    context "ログインしていない場合" do
      before do
        get :index
      end
      it "学習記録一覧ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe "GET #showのテスト" do
    before do
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
  
  describe "GET #editのテスト" do
    context "ログイン済みの場合" do
      before do
        sign_in user
        get :edit, params: { id: learning.id }
      end
      it "自分の学習記録編集ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "自分の学習記録編集ページが描画されること" do
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
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_path
      end
    end
    
    context "他人の学習記録の編集ページの場合" do
      before do
        sign_in user
        get :edit, params: { id: another_learning.id }
      end
      it "他人の学習記録の編集ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "その学習記録の詳細ページにリダイレクトされること" do
        expect(response).to redirect_to learning_path(another_learning)
      end
    end
  end
  
  describe "POST #createのテスト" do
    context "ログインしていて、かつ保存に成功した場合" do
      before do
        sign_in user
      end
      it "学習記録がデータベースに保存されること" do
        expect do
          post :create, params: { learning: attributes_for(:learning) }
        end.to change(user.learnings, :count).by(1)
      end
      it "保存後、保存した学習記録詳細ページにリダイレクトされること" do
        post :create, params: { learning: attributes_for(:learning) }
        expect(response).to redirect_to Learning.last
      end
    end
    
    context "ログインしていて、かつ保存に失敗した場合" do
      before do
        sign_in user
      end
      it "学習記録がデータベースに保存されないこと" do
        expect do
          post :create, params: { learning: attributes_for(:learning, title: nil) }
        end.to change(user.learnings, :count).by(0)
      end
      it "newテンプレートが表示されること" do
        post :create, params: { learning: attributes_for(:learning, title: nil) }
        expect(response).to render_template :new
      end
    end
    
    context "ログインしていない場合" do
      before do
        post :create, params: { learning: attributes_for(:learning) }
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe "PATCH #updateのテスト" do
    context "自分の学習記録であり、かつパラメータが妥当な場合" do
      before do
        sign_in user
        learning_params = { title: "タイトル変更" }
        patch :update, params: { id: learning.id, learning: learning_params }
      end
      it "学習記録が更新されること" do
        expect(learning.reload.title).to eq "タイトル変更"
      end
      it "更新後、更新した学習記録詳細ページにリダイレクトされること" do
        expect(response).to redirect_to learning_path(learning)
      end
      it "@learningというインスタンス変数が正しく定義されていること" do
        expect(assigns(:learning)).to eq learning
      end
    end
    
    context "自分の学習記録であり、かつパラメータが不正な場合" do
      before do
        sign_in user
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
    
    context "他のユーザーの学習記録を編集しようとする場合" do
      before do
        sign_in user
        another_learning_params = { title: "タイトル変更" }
        patch :update, params: { id: another_learning.id, learning: another_learning_params }
      end
      it "学習記録が更新されないこと" do
        expect(another_learning.reload.title).not_to eq "タイトル変更"
      end
      it "編集しようとした学習記録詳細ページにリダイレクトされること" do
        expect(response).to redirect_to learning_path(another_learning)
      end
    end
  end
  
  # describe "DELETE #destroyのテスト" do
  #   context "自分の学習記録を削除する場合" do
  #     before do
  #       sign_in user
  #     end
  #     it "学習記録が削除されること" do
  #       expect do
  #         delete :destroy, params: { id: learning }
  #       end.to change(Learning, :count).by(-1)
  #     end
  #     it "削除後、学習記録一覧ページにリダイレクトされること" do
  #       delete :destroy, params: { id: learning }
  #       expect(response).to redirect_to learnings_path
  #     end
  #   end
  # end
end
