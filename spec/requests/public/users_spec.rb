require "rails_helper"

RSpec.describe Public::UsersController, type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe "GET #index" do
    context "ログイン済みの場合" do
      before do
        create :alice
        create :bob
        sign_in user
        get users_url
      end

      it "リクエストは200 OK" do
        expect(response.status).to eq 200
      end
      it "ユーザー名が表示されること" do
        expect(response.body).to include "Alice"
        expect(response.body).to include "Bob"
      end
    end

    context "ログインしていない場合" do
      before do
        get users_url
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
    let(:alice) { create :alice }
    before do
      get user_url alice.id
    end

    it "リクエストは200 OK" do
      expect(response.status).to eq 200
    end
    it "ユーザー名と自己紹介が表示されること" do
      expect(response.body).to include "Alice"
      expect(response.body).to include "Aliceです。よろしくお願いします。"
    end
  end

  describe "GET #edit" do
    context "ログイン済みかつ自分の情報の場合" do
      before do
        sign_in user
        get edit_user_url user.id
      end

      it "リクエストは200 OK" do
        expect(response.status).to eq 200
      end
      it "ユーザー名と自己紹介が表示されること" do
        expect(response.body).to include "ユーザー"
        expect(response.body).to include "ユーザーです。よろしくお願いします。"
      end
    end
    
    context "ログイン済みかつ他のユーザー情報の場合" do
      before do
        sign_in user
        get edit_user_url another_user.id
      end

      it "リクエストは302 リダイレクト" do
        expect(response.status).to eq 302
      end
      it "マイページにリダイレクトされること" do
        expect(response).to redirect_to(user_url user.id)
      end
    end

    context "ログインしていない場合" do
      before do
        create :user
        get edit_user_url user.id
      end

      it "リクエストは302 リダイレクト" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "PATCH #update" do
    let(:alice) { create :alice }
    context "自分のユーザー情報であり、かつパラメータが妥当な場合" do
      before do
        sign_in user
      end
      
      it "リクエストは302 リダイレクト" do
        patch user_url user, params: { user: attributes_for(:alice) }
        expect(response.status).to eq 302
      end
      it "ユーザー名が更新されること" do
        expect do
          patch user_url user, params: { user: attributes_for(:alice) }
        end.to change { User.find(user.id).nickname }.from("ユーザー").to("Alice")
      end
      it "更新後、マイページにリダイレクトされること" do
        patch user_url user, params: { user: attributes_for(:alice) }
        expect(response).to redirect_to(user_url user)
      end
    end

    context "自分のユーザー情報であり、かつパラメータが不正な場合" do
      before do
        sign_in user
      end
      
      it "リクエストは200 OK" do
         patch user_url user, params: { user: attributes_for(:user, nickname: nil) }
        expect(response.status).to eq 200
      end
      it "ユーザー名が更新されないこと" do
        expect do
          patch user_url user, params: { user: attributes_for(:user, nickname: nil) }
        end.to_not change(User.find(user.id), :nickname)
      end
      it "エラーが表示されること" do
        patch user_url user, params: { user: attributes_for(:user, nickname: nil) }
        expect(response.body).to include "ニックネームを入力してください"
      end
    end

    context "他のユーザーの情報を編集しようとする場合" do
      before do
        sign_in user
      end

      it "ユーザー名が更新されないこと" do
        expect do
          patch user_url alice, params: { user: attributes_for(:bob) }
        end.to_not change(User.find(alice.id), :nickname)
      end
      it "マイページにリダイレクトされること" do
        patch user_url alice, params: { user: attributes_for(:bob) }
        expect(response).to redirect_to(user_url user)
      end
    end
  end
end
