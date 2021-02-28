require "rails_helper"

RSpec.describe "learning", type: :system do
  let(:user) { create(:user) }

  describe "学習記録を作成する" do
    before do
      sign_in_as(user)
    end

    context "作成に成功する場合" do
      it "トップ画面に'学習内容を記録'リンクがある。" do
        aggregate_failures do
          expect(current_path).to eq "/"
          expect(page).to have_content("学習内容を記録")
        end
      end

      it "'学習内容を記録'リンクを選択すると学習記録作成画面に遷移する。" do
        find(".learning-new-link").click
        aggregate_failures do
          expect(current_path).to eq "/learnings/new"
          expect(page).to have_content("学習内容を記録する")
        end
      end

      it "内容を入力し、'記録する'ボタンを選択すると学習記録詳細画面に遷移する。" do
        find(".learning-new-link").click
        learning = build(:learning)
        learning_create(learning)
        aggregate_failures do
          expect do
          click_button "記録する"
          end.to change(user.learnings, :count).by(1)
          expect(current_path).to eq "/learnings/1"
          expect(page).to have_content("学習内容を記録しました")
        end
      end
    end

    context "作成に失敗する場合" do
      before do
        find(".learning-new-link").click
      end

      it "内容を入力し、'記録する'ボタンを選択するとエラーメッセージが表示される。" do
        fill_in "学習日", with: "2021-01-01"
        fill_in "学習時間", with: "25"
        fill_in "タイトル", with: "あ" * 51
        aggregate_failures do
          expect do
          click_button "記録する"
          end.to change(user.learnings, :count).by(0)
          expect(page).to have_content("学習内容を記録する")
          expect(page).to have_content("タイトルは50文字以内で入力してください")
          expect(page).to have_content("学習時間は24以下の値にしてください")
          expect(page).to have_content("学習日：2021年01月01日の学習時間の合計が24時間を超えています")
        end
      end
    end
  end

  describe "学習記録一覧画面" do
    before do
      create(:learning_english, user: user)
      create(:learning_math, user: user)
      sign_in_as(user)
    end

    it "トップ画面に'学習記録を確認'リンクがある。" do
      aggregate_failures do
        expect(current_path).to eq "/"
        expect(page).to have_content("学習記録を確認")
      end
    end

    it "'学習記録を確認'リンクを選択すると学習記録一覧画面に遷移する。" do
      find(".learning-index-link").click
      aggregate_failures do
        expect(current_path).to eq "/learnings"
        expect(page).to have_content("#{user.nickname}さんの学習記録一覧")
      end
    end

    it "学習記録一覧画面に投稿した学習記録のタイトルが表示されている。" do
      find(".learning-index-link").click
      aggregate_failures do
        expect(page).to have_content("英語")
        expect(page).to have_content("数学")
      end
    end
  end

  describe "学習記録詳細画面" do
    before do
      create(:learning_english, user: user)
      sign_in_as(user)
    end

    it "学習記録一覧画面の学習記録を選択すると学習記録詳細画面に遷移する。" do
      find(".learning-index-link").click
      click_on "英語"
      aggregate_failures do
        expect(current_path).to eq "/learnings/1"
      end
    end

    it "学習記録の内容が表示される。" do
      find(".learning-index-link").click
      click_on "英語"
      aggregate_failures do
        expect(page).to have_content("学習記録詳細")
        expect(page).to have_content("英語")
        expect(page).to have_content("英語の勉強")
        expect(page).to have_content("2.0時間")
        expect(page).to have_content("学習内容を編集する")
      end
    end
  end

  describe "学習記録を編集する" do
    before do
      create(:learning_english, user: user)
      sign_in_as(user)
      find(".learning-index-link").click
      click_on "英語"
    end

    context "編集が成功する場合" do
      it "学習記録詳細画面の'学習内容を編集する'ボタンを選択すると学習記録編集画面に遷移する。" do
        click_on "学習内容を編集する"
        aggregate_failures do
          expect(current_path).to eq "/learnings/1/edit"
          expect(page).to have_content("学習内容を編集する")
        end
      end

      it "学習記録の内容が表示される。" do
        click_on "学習内容を編集する"
        aggregate_failures do
          expect(page).to have_field "タイトル", with: "英語"
          expect(page).to have_field "学習時間", with: "2.0"
          expect(page).to have_field "詳細", with: "英語の勉強"
        end
      end

      it "内容を編集し、'更新する'ボタンを選択すると学習記録詳細画面に遷移する。" do
        click_on "学習内容を編集する"
        fill_in "学習日", with: "2021-02-15"
        fill_in "学習時間", with: "15"
        fill_in "タイトル", with: "学習記録のタイトル更新"
        fill_in "詳細", with: "学習記録の詳細更新"
        fill_in "タグ", with: "python,html,css"
        choose "非公開"
        find(".learning-update-btn").click
        aggregate_failures do
          expect(current_path).to eq "/learnings/1"
          expect(page).to have_content("学習記録を更新しました")
        end
      end
    end

    context "編集が失敗する場合" do
      it "内容を入力し、'更新する'ボタンを選択するとエラーメッセージが表示される。" do
        click_on "学習内容を編集する"
        fill_in "学習日", with: "2021-02-02"
        fill_in "学習時間", with: "25"
        fill_in "タイトル", with: "い" * 51
        click_button "更新する"
        aggregate_failures do
          expect(page).to have_content("学習内容を編集する")
          expect(page).to have_content("タイトルは50文字以内で入力してください")
          expect(page).to have_content("学習時間は24以下の値にしてください")
          expect(page).to have_content("学習日：2021年02月02日の学習時間の合計が24時間を超えています")
        end
      end
    end
  end
end
  # describe "学習記録を削除する", js: true do
  #   before do
  #     create(:learning_english, user: user)
  #     sign_in_as(user)
  #     find(".learning-index-link").click
  #     click_on "英語"
  #     click_on "学習内容を編集する"
  #   end

  #   it "正確なパラメータを入力したら投稿が出来る。その後、投稿した学習記録の詳細画面に遷移する。" do
  #     expect(page).to have_current_path "/learnings/1/edit"
  #     sleep 3
  #   end
  # end
  