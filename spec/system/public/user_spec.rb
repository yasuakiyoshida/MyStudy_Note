require "rails_helper"

RSpec.describe "Users", type: :system do
  it "ユーザーの新規登録" do
    user = build(:user)
    visit root_path
    click_link "会員登録"
    fill_in "ニックネーム(2〜10文字)", with: user.nickname
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    fill_in "確認用パスワード", with: user.password_confirmation
    expect do
      click_button "新規登録する"
    end.to change(User, :count).by(1)
  end
end
