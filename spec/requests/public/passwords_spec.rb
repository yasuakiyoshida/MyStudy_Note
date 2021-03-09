require "rails_helper"

RSpec.describe Public::PasswordsController, type: :request do

  describe "GET #new" do
    before do
      get new_user_password_url
    end

    it "リクエストは200 OK" do
      expect(response.status).to eq 200
    end
  end
end
