require "rails_helper"

RSpec.describe "passwords", type: :system do
  let(:user) { create(:user) }

  describe "パスワード再設定画面" do
    it "'ログインする'リンクを選択するとログイン画面に遷移する" do
      visit password_path
      click_on "ログインする"
      aggregate_failures do
        expect(current_path).to eq "/sign_in"
        expect(page).to have_content("ログイン")
      end
    end

    it "'会員登録する'リンクを選択すると会員登録画面に遷移する" do
      visit password_path
      click_on "会員登録する"
      aggregate_failures do
        expect(current_path).to eq "/sign_up"
        expect(page).to have_content("会員登録")
      end
    end
  end
end
