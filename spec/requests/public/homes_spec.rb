require "rails_helper"

RSpec.describe Public::HomesController, type: :request do

  describe "GET #top" do
    before do
      create :learning
      get root_url
    end

    it "リクエストは200 OK" do
      expect(response.status).to eq 200
    end
    it "見出しが表示されること" do
      expect(response.body).to include "自分だけの学習ノートを作成しよう！"
    end
    it "学習記録のタイトルが表示されること" do
      expect(response.body).to include "学習記録のタイトル"
    end
  end

  describe "GET #common_learnings" do
    before do
      create :learning
      get common_learnings_url
    end

    it "リクエストは200 OK" do
      expect(response.status).to eq 200
    end
    it "学習記録のタイトルが表示されること" do
      expect(response.body).to include "学習記録のタイトル"
    end
  end
end
