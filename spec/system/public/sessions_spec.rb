require "rails_helper"

RSpec.describe "userログインとログアウト", type: :system do
  let(:user) { create(:user) }
  context "ログインできる場合" do
    it "正確なパラメータを入力したらログインでき、トップ画面に遷移する。その後、ログアウトする。" do
      visit root_path
      click_link "ログイン"
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログインする"
      aggregate_failures do
        expect(current_path).to eq "/"
        expect(page).to have_content "ログインしました。"
      end

      find(".logout-link").click
      aggregate_failures do
        expect(current_path).to eq "/"
        expect(page).to have_link "ログイン"
        expect(page).to have_content "ログアウトしました。"
      end
    end
  end

  context "ログインできない場合" do
    it "不正なパラメータを入力したらログインできない。その後、再度ログイン画面へ。" do
      visit root_path
      click_link "ログイン"
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "111111"
      click_button "ログインする"
      aggregate_failures do
        expect(current_path).to eq "/sign_in"
        expect(page).to have_content "メールアドレスまたはパスワードが違います。"
      end
    end
  end
end
