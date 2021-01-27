require "rails_helper"

RSpec.describe Public::LearningTimesController, type: :request do
  let(:user) { create(:user) }

  describe "GET #index" do
    context "ログイン済みの場合" do
      before do
        sign_in user
        get user_learning_times_url user.id
      end

      it "リクエストは200 OK" do
        expect(response.status).to eq 200
      end
      it "ユーザー名が表示されること" do
        expect(response.body).to include "ユーザー"
      end
    end

    context "ログインしていない場合" do
      before do
        get user_learning_times_url user.id
      end

      it "リクエストは302 リダイレクト" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
