require "rails_helper"

RSpec.describe Public::SessionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

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

  # describe "POST #createのテスト" do
  #   context "入力されたパラメータが妥当な場合" do
  #     before do
  #       @request.env["devise.mapping"] = Devise.mappings[:user]
  #     end
  #     it "ログインが成功すること" do
  #       post :create, params: { email: user.email, password: user.password }
  #       expect(response).to be_successful
  #     end
  #     # it "ログイン後、トップページにリダイレクトされること" do
  #     #   post :create, params: { email: user.email, password: user.password }
  #     #   expect(response).to redirect_to root_path
  #     # end
  #   end

  #   context "入力されたパラメータが不正な場合" do
  #     before do
  #       @request.env["devise.mapping"] = Devise.mappings[:user]
  #     end
  #     it "ログインが失敗すること" do
  #       post :create, params: { email: another_user.email, password: user.password  }
  #       expect(response).to_not be_successful
  #     end
  #     it "newテンプレートが表示されること" do
  #       post :create, params: { email: "aaaaa@example.com", password: user.password }
  #       expect(response).to render_template :new
  #     end
  #   end
  # end
end
