require "rails_helper"

RSpec.describe "home", type: :system do
  let(:user) { create(:user) }
  let(:alice) { create(:alice) }
  let(:bob) { create(:bob) }
  let!(:learning) { create(:learning, user: user) }
  let!(:alice_learning) { create(:learning_english, user: alice) }
  let!(:bob_learning) { create(:learning_math, user: bob) }

  describe "トップ画面" do
    before do
      visit root_path
    end

    context "ログイン前" do

      it "ヘッダに'ホーム','みんなの学習記録','会員登録','ログイン'のリンクがある。" do
        aggregate_failures do
          expect(current_path).to eq "/"
          expect(page).to have_content("ホーム")
          expect(page).to have_content("みんなの学習記録")
          expect(page).to have_content("会員登録")
          expect(page).to have_content("ログイン")
        end
      end

      it "'ホーム'リンクを選択するとトップ画面に遷移する。" do
        find(".home-top-link").click
        aggregate_failures do
          expect(current_path).to eq "/"
          expect(page).to have_content("「学習内容の記録&共有・やることリストの作成」ができるサイトです。")
        end
      end

      it "'みんなの学習記録'リンクを選択するとみんなの学習記録一覧画面に遷移する。" do
        find(".common-learnings-link").click
        aggregate_failures do
          expect(current_path).to eq "/common_learnings"
          expect(page).to have_content("みんなの学習記録")
        end
      end

      it "'会員登録'リンクを選択すると会員登録画面に遷移する。" do
        find(".sign-up-link").click
        aggregate_failures do
          expect(current_path).to eq "/sign_up"
          expect(page).to have_content("会員登録")
        end
      end

      it "'ログイン'リンクを選択するとログイン画面に遷移する。" do
        find(".sign-in-link").click
        aggregate_failures do
          expect(current_path).to eq "/sign_in"
          expect(page).to have_content("ログイン")
        end
      end

      it "投稿された学習記録が表示されている。" do
        aggregate_failures do
          expect(page).to have_content("学習記録のタイトル")
          expect(page).to have_content("英語")
          expect(page).to have_content("数学")
          expect(page).to have_content("by ユーザー")
          expect(page).to have_content("by Alice")
          expect(page).to have_content("by Bob")
        end
      end

      it "学習記録のタイトルを選択すると学習記録詳細画面に遷移する" do
        click_on "学習記録のタイトル"
        aggregate_failures do
          expect(current_path).to eq "/learnings/#{learning.id}"
          expect(page).to have_content("学習記録詳細")
          expect(page).to have_content("学習記録のタイトル")
          expect(page).to have_content("学習記録の詳細")
          expect(page).to have_content("1.5時間")
          expect(page).to have_content("ユーザー")
        end
      end

      it "学習記録の画像を選択すると学習記録詳細画面に遷移する" do
        first(".image-link-border").click
        aggregate_failures do
          expect(current_path).to eq "/learnings/#{bob_learning.id}"
          expect(page).to have_content("学習記録詳細")
          expect(page).to have_content("数学")
          expect(page).to have_content("数学の勉強")
          expect(page).to have_content("3.5時間")
          expect(page).to have_content("Bob")
        end
      end

      it "学習記録のユーザー名を選択するとユーザー詳細画面に遷移する" do
        click_on "Alice"
        aggregate_failures do
          expect(current_path).to eq "/users/#{alice.id}"
          expect(page).to have_content("ユーザー情報")
          expect(page).to have_content("Aliceです。よろしくお願いします。")
        end
      end

      it "'もっと見る>>'リンクを選択するとみんなの学習記録一覧画面に遷移する。" do
        click_on "もっと見る>>"
        aggregate_failures do
          expect(current_path).to eq "/common_learnings"
          expect(page).to have_content("みんなの学習記録")
        end
      end
    end

    context "ログイン後" do
    end
  end
end
