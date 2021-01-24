require 'rails_helper'

RSpec.describe Public::HomesController, type: :controller do
  
  describe 'GET #topのテスト' do
    before do
      get :top
    end
    
    it "トップページへのリクエストは200 OKとなること" do
      expect(response.status).to eq 200
    end
    
    it "トップページが描画されること" do
      expect(response).to render_template :top
    end
  end
end