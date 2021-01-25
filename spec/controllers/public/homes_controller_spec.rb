require "rails_helper"

RSpec.describe Public::HomesController, type: :controller do
  let(:learning) { create(:learning) }
  
  describe "GET #topのテスト" do
    before do
      get :top
    end
    it "トップページへのリクエストは200 OKとなること" do
      expect(response.status).to eq 200
    end
    it "トップページが描画されること" do
      expect(response).to render_template :top
    end
    it "@learningsというインスタンス変数が正しく定義されていること" do
      expect(assigns(:learnings)).to match_array [learning]
    end
  end
  
  describe "GET #common_learningsのテスト" do
    before do
      get :common_learnings
    end
    it "みんなの学習記録一覧ページへのリクエストは200 OKとなること" do
      expect(response.status).to eq 200
    end
    it "みんなの学習記録一覧ページが描画されること" do
      expect(response).to render_template :common_learnings
    end
    it "@learningsというインスタンス変数が正しく定義されていること" do
      expect(assigns(:learnings)).to match_array [learning]
    end
  end
end
