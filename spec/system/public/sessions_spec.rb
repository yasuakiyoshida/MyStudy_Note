require "rails_helper"

RSpec.describe "sessions", type: :system do
  let(:user) { create(:user) }

  describe "ログインする" do
    context "成功する場合" do
      it "内容を入力し、'ログインする'ボタンを選択するとトップ画面に遷移する。" do
        visit root_path
        click_link "ログイン"
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログインする"
        aggregate_failures do
          expect(current_path).to eq "/"
          expect(page).to have_content "ログインしました。"
        end
      end
    end

    context "失敗する場合" do
      it "内容を入力し、'ログインする'ボタンを選択するとエラーメッセージが表示される。" do
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

  describe "ログアウトする" do
    before do
      sign_in_as(user)
    end

    it "ログアウトしたらトップ画面に遷移する。" do
      find(".logout-link").click
      aggregate_failures do
        expect(current_path).to eq "/"
        expect(page).to have_link "ログイン"
        expect(page).to have_content "ログアウトしました。"
      end
    end
  end
end
