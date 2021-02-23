require "rails_helper"

RSpec.describe "adminログインとログアウト", type: :system do
  let(:admin) { create(:admin) }
  context "ログインできる場合" do
    it "正確なパラメータを入力したらログインでき、管理者側ユーザー一覧画面に遷移する。その後、ログアウトして管理者ログイン画面に遷移する。" do
      visit admin_session_path
      fill_in "メールアドレス", with: admin.email
      fill_in "パスワード", with: admin.password
      click_button "ログインする"
      aggregate_failures do
        expect(current_path).to eq "/admins/users"
        expect(page).to have_content "ログインしました。"
      end

      find(".logout-link").click
      aggregate_failures do
        expect(current_path).to eq "/admins/sign_in"
        expect(page).to have_link "ログイン"
        expect(page).to have_content "ログアウトしました。"
      end
    end
  end

  context "ログインできない場合" do
    it "不正なパラメータを入力したらログインできない。その後、再度管理者ログイン画面へ。" do
      visit admin_session_path
      fill_in "メールアドレス", with: admin.email
      fill_in "パスワード", with: "111111"
      click_button "ログインする"
      aggregate_failures do
        expect(current_path).to eq "/admins/sign_in"
        expect(page).to have_content "メールアドレスまたはパスワードが違います。"
      end
    end
  end
end
