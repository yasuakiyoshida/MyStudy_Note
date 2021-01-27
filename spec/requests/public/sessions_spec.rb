require "rails_helper"

RSpec.describe Public::SessionsController, type: :request do
  describe "GET #new" do
    before do
      get new_user_session_url
    end

    it "リクエストは200 OK" do
      expect(response.status).to eq 200
    end
  end
end
