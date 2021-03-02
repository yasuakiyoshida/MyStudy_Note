require "rails_helper"

RSpec.describe "registrations", type: :system do
  describe "ユーザー新規登録" do
    context "新規登録できる場合" do
      it "内容を入力し、'新規登録する'ボタンを選択するとトップ画面に遷移する。" do
        user = build(:user)
        visit root_path
        click_link "会員登録"
        fill_in "ニックネーム(2〜10文字)", with: user.nickname
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        fill_in "確認用パスワード", with: user.password_confirmation
        aggregate_failures do
          expect do
          click_button "新規登録する"
          end.to change(User, :count).by(1)
          expect(current_path).to eq "/"
          expect(page).to have_content("アカウント登録が完了しました")
        end
      end
    end

    context "新規登録できない場合" do
      it "内容を入力し、'新規登録する'ボタンを選択するとエラーメッセージが表示される。" do
        user = build(:user)
        visit root_path
        click_link "会員登録"
        fill_in "ニックネーム(2〜10文字)", with: "あ"
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        fill_in "確認用パスワード", with: user.password_confirmation
        aggregate_failures do
          expect do
          click_button "新規登録する"
          end.to change(User, :count).by(0)
          expect(current_path).to eq "/sign_up"
          expect(page).to have_content("エラーが発生したため ユーザ は保存されませんでした。")
          expect(page).to have_content("ニックネームは2文字以上で入力してください")
        end
      end
    end
  end
end
