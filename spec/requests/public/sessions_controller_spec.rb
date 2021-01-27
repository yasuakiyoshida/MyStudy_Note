require "rails_helper"

RSpec.describe Public::SessionsController, type: :controller do
  describe "GET #newのテスト" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new
    end

    it "ログインページへのリクエストは200 OKとなること" do
      expect(response.status).to eq 200
    end
    it "ログインページが描画されること" do
      expect(response).to render_template :new
    end
  end
end
