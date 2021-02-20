require "rails_helper"

RSpec.describe "user新規登録", type: :system do
  context "新規登録できる場合" do
    it "正確なパラメータを入力したら新規登録が出来る。その後、トップ画面に遷移する。" do
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
      expect(current_path).to eq "/"
      expect(page).to have_content "アカウント登録が完了しました"
    end
  end

  context "新規登録できない場合" do
    it "不正なパラメータを入力したら新規登録できない。その後、再度新規登録画面へ。" do
      user = build(:user)
      visit root_path
      click_link "会員登録"
      fill_in "ニックネーム(2〜10文字)", with: "あ"
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      fill_in "確認用パスワード", with: user.password_confirmation
      expect do
        click_button "新規登録する"
      end.to change(User, :count).by(0)
      expect(current_path).to eq "/sign_up"
      expect(page).to have_content "エラーが発生したため ユーザ は保存されませんでした。"
      expect(page).to have_content "ニックネームは2文字以上で入力してください"
    end
  end
end
