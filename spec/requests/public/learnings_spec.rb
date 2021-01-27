require "rails_helper"

RSpec.describe Public::LearningsController, type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe "GET #new" do
    context "ログイン済みの場合" do
      before do
        sign_in user
        get new_learning_url
      end

      it "リクエストは200 OK" do
        expect(response.status).to eq 200
      end
    end

    context "ログインしていない場合" do
      before do
        get new_learning_url
      end

      it "リクエストは302 リダイレクト" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "GET #index" do
    context "ログイン済みの場合" do
      before do
        create(:learning_english, user: user)
        create(:learning_math, user: user)
        sign_in user
        get learnings_url
      end

      it "リクエストは200 OK" do
        expect(response.status).to eq 200
      end
      it "学習記録のタイトルが表示されること" do
        expect(response.body).to include "英語"
        expect(response.body).to include "数学"
      end
    end

    context "ログインしていない場合" do
      before do
        get learnings_url
      end

      it "リクエストは302 リダイレクト" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "GET #show" do
    let(:learning_english) { create :learning_english }
    before do
      get learning_url learning_english.id
    end

    it "リクエストは200 OK" do
      expect(response.status).to eq 200
    end
    it "学習記録のタイトルと詳細が表示されること" do
      expect(response.body).to include "英語"
      expect(response.body).to include "英語の勉強"
    end
  end

  describe "GET #edit" do
    context "ログイン済みかつ自分の学習記録の場合" do
      let(:learning_english) { create(:learning_english, user: user) }
      before do
        sign_in user
        get edit_learning_url learning_english.id
      end

      it "リクエストは200 OK" do
        expect(response.status).to eq 200
      end
      it "学習記録のタイトルと詳細が表示されること" do
        expect(response.body).to include "英語"
        expect(response.body).to include "英語の勉強"
      end
    end
    
    context "ログイン済みかつ他人の学習記録の場合" do
      let(:learning_english) { create(:learning_english, user: another_user) }
      before do
        sign_in user
        get edit_learning_url learning_english.id
      end

      it "リクエストは302 リダイレクト" do
        expect(response.status).to eq 302
      end
      it "その学習記録の詳細ページにリダイレクトされること" do
        expect(response).to redirect_to(learning_url learning_english)
      end
    end

    context "ログインしていない場合" do
      let(:learning_english) { create :learning_english }
      before do
        get edit_learning_url learning_english.id
      end

      it "リクエストは302 リダイレクト" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "POST #create" do
    context "ログイン済みかつ保存に成功した場合" do
      before do
        sign_in user
      end

      it "学習記録がデータベースに保存されること" do
        expect do
          post learnings_url, params: { learning: attributes_for(:learning, user: user) }
        end.to change(user.learnings, :count).by(1)
      end
      it "保存後、保存した学習記録詳細ページにリダイレクトされること" do
        post learnings_url, params: { learning: attributes_for(:learning, user: user) }
        expect(response).to redirect_to Learning.last
      end
    end

    context "ログイン済みかつ保存に失敗した場合" do
      before do
        sign_in user
      end

      it "学習記録がデータベースに保存されないこと" do
        expect do
          post learnings_url, params: { learning: attributes_for(:learning, title: nil, user: user) }
        end.to change(user.learnings, :count).by(0)
      end
      it "エラーが表示されること" do
        post learnings_url, params: { learning: attributes_for(:learning, title: nil, user: user) }
        expect(response.body).to include "タイトルを入力してください"
      end
    end

    context "ログインしていない場合" do
      before do
        post learnings_url, params: { learning: attributes_for(:learning, user: user) }
      end

      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "PATCH #update" do
    context "自分の学習記録であり、かつパラメータが妥当な場合" do
      let(:learning_english) { create(:learning_english, user: user) }
      before do
        sign_in user
      end
      
      it "リクエストは302 リダイレクト" do
        patch learning_url learning_english, params: { learning: attributes_for(:learning_math) }
        expect(response.status).to eq 302
      end
      it "学習記録のタイトルが更新されること" do
        expect do
          patch learning_url learning_english, params: { learning: attributes_for(:learning_math) }
        end.to change { Learning.find(learning_english.id).title }.from("英語").to("数学")
      end
      it "更新後、更新した学習記録詳細ページにリダイレクトされること" do
        patch learning_url learning_english, params: { learning: attributes_for(:learning_math) }
        expect(response).to redirect_to(learning_url learning_english)
      end
    end

    context "自分の学習記録であり、かつパラメータが不正な場合" do
      let(:learning_english) { create(:learning_english, user: user) }
      before do
        sign_in user
      end
      
      it "リクエストは200 OK" do
        patch learning_url learning_english, params: { learning: attributes_for(:learning_math, title: nil) }
        expect(response.status).to eq 200
      end
      it "学習記録のタイトルが更新されないこと" do
        expect do
          patch learning_url learning_english, params: { learning: attributes_for(:learning_math, title: nil) }
        end.to_not change(Learning.find(learning_english.id), :title)
      end
      it "エラーが表示されること" do
        post learnings_url, params: { learning: attributes_for(:learning, title: nil, user: user) }
        expect(response.body).to include "タイトルを入力してください"
      end
    end

    context "他のユーザーの学習記録を編集しようとする場合" do
      let(:learning_english) { create(:learning_english, user: another_user) }
      before do
        sign_in user
      end

      it "学習記録が更新されないこと" do
        expect do
          patch learning_url learning_english, params: { learning: attributes_for(:learning_math) }
        end.to_not change(Learning.find(learning_english.id), :title)
      end
      it "編集しようとした学習記録詳細ページにリダイレクトされること" do
        patch learning_url learning_english, params: { learning: attributes_for(:learning_math) }
        expect(response).to redirect_to(learning_url learning_english)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:learning) { create(:learning, user: user) }
    before do
      sign_in user
    end
    
    it "リクエストは302 リダイレクト" do
      delete learning_url learning
      expect(response.status).to eq 302
    end
    it "学習記録が削除されること" do
      expect do
        delete learning_url learning
      end.to change(user.learnings, :count).by(-1)
    end
    it "学習記録一覧ページにリダイレクトされること" do
      delete learning_url learning
      expect(response).to redirect_to learnings_url
    end
  end
end
