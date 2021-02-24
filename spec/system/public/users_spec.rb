require "rails_helper"

RSpec.describe "user詳細、編集", type: :system do
  let(:user) { create(:user) }

  context "user詳細画面" do
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

  context "user編集画面" do
    before do
      sign_in_as(user)
      find(".mypage-link").click
      find(".profile-edit-btn").click
    end

    it "登録したユーザー名が正確に表示されている。" do
      aggregate_failures do
        expect(current_path).to eq "/users/#{user.id}/edit"
        expect(page).to have_field "ニックネーム(2〜10文字の範囲)", with: "ユーザー"
        expect(page).to have_field "メールアドレス", with: user.email
      end
    end

    it "ユーザー情報を編集後、ユーザー詳細画面に遷移する。ユーザー詳細画面には編集後の情報が表示されている。" do
      fill_in "ニックネーム(2〜10文字の範囲)", with: "ユーザー名更新"
      fill_in "自己紹介", with: "自己紹介を更新しました。"
      fill_in "メールアドレス", with: "userupdate@example.com"
      click_button "更新する"
      # ユーザー詳細画面の確認
      aggregate_failures do
        expect(current_path).to eq "/users/#{user.id}"
        expect(find('.username').text).to eq "ユーザー名更新"
        expect(find('.biography-text').text).to eq "自己紹介を更新しました。"
      end

      find(".profile-edit-btn").click
      # ユーザー編集画面の確認
      aggregate_failures do
        expect(current_path).to eq "/users/#{user.id}/edit"
        expect(page).to have_field "ニックネーム(2〜10文字の範囲)", with: "ユーザー名更新"
        expect(page).to have_field "自己紹介", with: "自己紹介を更新しました。"
        expect(page).to have_field "メールアドレス", with: "userupdate@example.com"
      end
    end
  end
end
