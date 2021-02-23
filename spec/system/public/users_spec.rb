require "rails_helper"

RSpec.describe "user詳細、編集", type: :system do
  let(:user) { create(:user) }

  describe "user詳細画面" do
    context "ログイン済みの場合" do
      before do
        sign_in_as(user)
        find(".mypage-link").click
      end

      it "登録したユーザー名が正確に表示されている。" do
        aggregate_failures do
          expect(current_path).to eq "/users/#{user.id}"
          expect(find('.username').text).to eq "ユーザー"
        end
      end
    end
  end

  describe "user詳細画面" do
    context "ログイン済みの場合" do
      before do
        sign_in_as(user)
        find(".mypage-link").click
        find(".profile-edit-btn").click
      end

      it "ユーザー情報を編集後、ユーザー詳細画面に遷移する。ユーザー詳細画面には編集後の情報が表示される。" do
        aggregate_failures do
          expect(current_path).to eq "/users/#{user.id}/edit"
          expect(page).to have_field "ニックネーム(2〜10文字の範囲)", with: "ユーザー"
        end
      end
    end
  end
end
