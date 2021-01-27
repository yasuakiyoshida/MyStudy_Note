require "rails_helper"

RSpec.describe Admins::SessionsController, type: :request do
  describe "GET #new" do
    before do
      get new_admin_session_url
    end

    it "リクエストが成功すること" do
      expect(response.status).to eq 200
    end
  end
end
