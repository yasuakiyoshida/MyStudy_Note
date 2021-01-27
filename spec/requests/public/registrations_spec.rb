require "rails_helper"

RSpec.describe Public::RegistrationsController, type: :request do

  describe "GET #new" do
    before do
      get new_user_registration_url
    end
    
    it "リクエストが成功すること" do
      expect(response.status).to eq 200
    end
  end
end
