require "rails_helper"

RSpec.describe "admin/sessions", type: :system do
  let(:admin) { create(:admin) }

  describe "管理者ログイン" do
    context "成功する場合" do
      it "内容を入力し、'ログインする'ボタンを選択すると管理者ユーザー一覧画面に遷移する。" do
        visit admin_session_path
        fill_in "メールアドレス", with: admin.email
        fill_in "パスワード", with: admin.password
        click_button "ログインする"
        aggregate_failures do
          expect(current_path).to eq "/admins/users"
          expect(page).to have_content "ログインしました。"
        end
      end
    end

    context "失敗する場合" do
      it "内容を入力し、'ログインする'ボタンを選択するとエラーメッセージが表示される。" do
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

  describe "管理者ログアウト" do
    before do
      admin_sign_in_as(admin)
    end

    it "ログアウトしたら管理者ログイン画面に遷移する。" do
      find(".logout-link").click
      aggregate_failures do
        expect(current_path).to eq "/admins/sign_in"
        expect(page).to have_link "ログイン"
        expect(page).to have_content "ログアウトしました。"
      end
    end
  end
end
