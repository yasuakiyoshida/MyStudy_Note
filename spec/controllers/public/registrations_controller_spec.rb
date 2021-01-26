require "rails_helper"

RSpec.describe Public::RegistrationsController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #newのテスト" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new
    end

    it "会員登録ページへのリクエストは200 OKとなること" do
      expect(response.status).to eq 200
    end
    it "会員登録ページが描画されること" do
      expect(response).to render_template :new
    end
  end
end
