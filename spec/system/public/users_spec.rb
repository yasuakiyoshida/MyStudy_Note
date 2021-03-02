require "rails_helper"

RSpec.describe "user", type: :system do
  let(:user) { create(:user) }

  describe "ユーザー詳細画面" do
    before do
      sign_in_as(user)
      find(".mypage-link").click
    end

    it "登録したユーザー名が正確に表示されている。" do
      aggregate_failures do
        expect(current_path).to eq "/users/#{user.id}"
        expect(find('.username').text).to eq "ユーザー"
        expect(page).to have_content("プロフィールを編集する")
      end
    end
  end

  describe "ユーザー情報を編集する" do
    context "編集に成功する場合" do
      before do
        sign_in_as(user)
        find(".mypage-link").click
        find(".profile-edit-btn").click
      end

      it "編集画面に登録したユーザー情報が表示されている。" do
        aggregate_failures do
          expect(current_path).to eq "/users/#{user.id}/edit"
          expect(page).to have_field "ニックネーム(2〜10文字の範囲)", with: "ユーザー"
          expect(page).to have_field "メールアドレス", with: user.email
        end
      end

      it "編集後、ユーザー詳細画面に遷移する。ユーザー詳細画面には編集後の情報が表示されている。" do
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
        # 再度ユーザー編集画面の確認
        aggregate_failures do
          expect(current_path).to eq "/users/#{user.id}/edit"
          expect(page).to have_field "ニックネーム(2〜10文字の範囲)", with: "ユーザー名更新"
          expect(page).to have_field "自己紹介", with: "自己紹介を更新しました。"
          expect(page).to have_field "メールアドレス", with: "userupdate@example.com"
        end
      end
    end

    context "編集に失敗する場合" do
      before do
        sign_in_as(user)
        find(".mypage-link").click
        find(".profile-edit-btn").click
      end

      it "内容を入力し、'更新する'ボタンを選択するとエラーメッセージが表示される。" do
        fill_in "ニックネーム(2〜10文字の範囲)", with: "あ" * 11
        fill_in "自己紹介", with: "自己紹介を更新しました。"
        fill_in "メールアドレス", with: "userupdate@example.com"
        click_button "更新する"
        aggregate_failures do
          expect(page).to have_content("ユーザー情報編集")
          expect(page).to have_content("ニックネームは10文字以内で入力してください")
        end
      end
    end
  end

  describe "ユーザー一覧画面" do
    before do
      create :alice
      create :bob
      sign_in_as(user)
    end

    it "トップ画面に'ユーザー一覧'リンクがある。" do
      aggregate_failures do
        expect(current_path).to eq "/"
        expect(page).to have_content("ユーザー一覧")
      end
    end

    it "'ユーザー一覧'リンクを選択するとユーザー一覧画面に遷移する。" do
      find(".user-index-link").click
      aggregate_failures do
        expect(current_path).to eq "/users"
        expect(page).to have_content("ユーザー一覧")
      end
    end

    it "ユーザー一覧画面に登録されたユーザー名が表示されている。" do
      find(".user-index-link").click
      aggregate_failures do
        expect(page).to have_content("Alice")
        expect(page).to have_content("Bob")
      end
    end
  end
end
