require "rails_helper"

RSpec.describe "home", type: :system do
  let(:user) { create(:user) }
  let(:alice) { create(:alice) }
  let(:bob) { create(:bob) }
  let!(:learning) { create(:learning, user: user) }
  let!(:alice_learning) { create(:learning_english, user: alice) }
  let!(:bob_learning) { create(:learning_math, user: bob) }

  describe "トップ画面" do
    context "ログイン前" do
      before do
        visit root_path
      end

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
      before do
        sign_in_as(user)
      end

      it "ヘッダ一段目に'ホーム','ユーザー一覧','みんなの学習記録','ログアウト'のリンクがある。" do
        aggregate_failures do
          expect(current_path).to eq "/"
          expect(page).to have_content("ホーム")
          expect(page).to have_content("ユーザー一覧")
          expect(page).to have_content("みんなの学習記録")
          expect(page).to have_content("ログアウト")
        end
      end

      it "ヘッダ二段目に'マイページ','過去の学習時間','学習記録の確認','学習内容を記録','ToDoリスト'のリンクがある。" do
        aggregate_failures do
          expect(page).to have_content("マイページ")
          expect(page).to have_content("過去の学習時間")
          expect(page).to have_content("学習記録を確認")
          expect(page).to have_content("学習内容を記録")
          expect(page).to have_content("ToDoリスト")
        end
      end

      it "'ホーム'リンクを選択するとトップ画面に遷移する。" do
        find(".home-top-link").click
        aggregate_failures do
          expect(current_path).to eq "/"
          expect(page).to have_content("「学習内容の記録&共有・やることリストの作成」ができるサイトです。")
        end
      end

      it "'ユーザー一覧'リンクを選択するとユーザー一覧画面に遷移する。" do
        find(".user-index-link").click
        aggregate_failures do
          expect(current_path).to eq "/users"
          expect(page).to have_content("ユーザー一覧")
        end
      end

      it "'みんなの学習記録'リンクを選択するとみんなの学習記録一覧画面に遷移する。" do
        find(".common-learnings-link").click
        aggregate_failures do
          expect(current_path).to eq "/common_learnings"
          expect(page).to have_content("みんなの学習記録")
        end
      end

      it "'ログアウト'リンクを選択するとログアウトし、トップ画面に遷移する。" do
        find(".logout-link").click
        aggregate_failures do
          expect(current_path).to eq "/"
          expect(page).to have_content("ログアウトしました。")
          expect(page).to have_content("ホーム")
          expect(page).to have_content("みんなの学習記録")
          expect(page).to have_content("会員登録")
          expect(page).to have_content("ログイン")
        end
      end

      it "'マイページ'リンクを選択するとマイページに遷移する。" do
        find(".mypage-link").click
        aggregate_failures do
          expect(current_path).to eq "/users/#{user.id}"
          expect(page).to have_content("マイページ")
        end
      end

      it "'過去の学習時間'リンクを選択すると学習時間確認画面に遷移する。" do
        find(".learning-times-link").click
        aggregate_failures do
          expect(current_path).to eq "/users/#{user.id}/learning_times"
          expect(page).to have_content("#{user.nickname}さんの学習時間")
        end
      end

      it "'学習記録を確認'リンクを選択すると学習記録一覧画面に遷移する。" do
        find(".learning-index-link").click
        aggregate_failures do
          expect(current_path).to eq "/learnings"
          expect(page).to have_content("#{user.nickname}さんの学習記録一覧")
        end
      end

      it "'学習内容を記録'リンクを選択すると学習記録作成画面に遷移する。" do
        find(".learning-new-link").click
        aggregate_failures do
          expect(current_path).to eq "/learnings/new"
          expect(page).to have_content("学習内容を記録する")
        end
      end

      it "'ToDoリスト'リンクを選択するとToDoリスト一覧画面に遷移する。" do
        find(".task-index-link").click
        aggregate_failures do
          expect(current_path).to eq "/tasks"
          expect(page).to have_content("ToDoリスト一覧")
        end
      end
    end
  end

  describe "みんなの学習記録一覧画面" do
    before do
      visit root_path
      find(".common-learnings-link").click
    end

    it "'みんなの学習記録'リンクを選択するとみんなの学習記録一覧画面に遷移する。" do
      aggregate_failures do
        expect(current_path).to eq "/common_learnings"
        expect(page).to have_content("みんなの学習記録")
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

    it "検索バーが表示されている。" do
      aggregate_failures do
        expect(page).to have_button("検索")
        expect(page).to have_selector(".search-form")
      end
    end
  end
end
