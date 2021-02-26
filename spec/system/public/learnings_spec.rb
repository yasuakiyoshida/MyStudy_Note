require "rails_helper"

RSpec.describe "learning", type: :system do
  let(:user) { create(:user) }

  context "学習記録を作成する" do
    before do
      sign_in_as(user)
      find(".learning-new-link").click
    end

    it "正確なパラメータを入力したら投稿が出来る。その後、投稿した学習記録の詳細画面に遷移する。" do
      learning = build(:learning)
      learning_create(learning)
      aggregate_failures do
        expect do
        click_button "記録する"
        end.to change(user.learnings, :count).by(1)
        expect(current_path).to eq "/learnings/1"
        expect(page).to have_content "学習内容を記録しました"
        expect(page).to have_content "学習記録のタイトル"
        expect(page).to have_content "2021年01月01日"
        expect(page).to have_content "1.5時間"
        expect(page).to have_content "学習記録の詳細"
        expect(page).to have_content "rails"
        expect(page).to have_content "ruby"
      end
    end

    it "不正なパラメータを入力したら投稿できない。その後、学習記録作成画面が表示される。" do
      fill_in "学習日", with: "2021-01-01"
      fill_in "学習時間", with: "25"
      fill_in "タイトル", with: "あ" * 51
      aggregate_failures do
        expect do
        click_button "記録する"
        end.to change(user.learnings, :count).by(0)
        expect(page).to have_content "学習内容を記録する"
        expect(page).to have_content "タイトルは50文字以内で入力してください"
        expect(page).to have_content "学習時間は24以下の値にしてください"
        expect(page).to have_content "学習日：2021年01月01日の学習時間の合計が24時間を超えています"
      end
    end
  end

  context "学習記録を編集する" do
    before do
      learning = build(:learning)
      sign_in_as(user)
      find(".learning-new-link").click
      learning_create(learning)
      click_button "記録する"
    end

    it "投稿した学習記録が正確に表示されている。" do
      find(".learning-edit-btn").click
      aggregate_failures do
        expect(current_path).to eq "/learnings/1/edit"
        expect(page).to have_content "学習内容を編集する"
        expect(page).to have_field "タイトル", with: "学習記録のタイトル"
        expect(page).to have_field "学習日", with: "2021-01-01"
        expect(page).to have_field "学習時間", with: "1.5"
        expect(page).to have_field "詳細", with: "学習記録の詳細"
        expect(page).to have_field "タグ", with: "rails,ruby"
      end
    end

    it "学習記録を編集後、学習記録詳細画面に遷移する。学習記録詳細画面には編集後の情報が表示されている。" do
      find(".learning-edit-btn").click
      fill_in "学習日", with: "2021-02-01"
      fill_in "学習時間", with: "20"
      fill_in "タイトル", with: "学習記録のタイトル更新"
      fill_in "詳細", with: "学習記録の詳細更新"
      fill_in "タグ", with: "python,html,css"
      choose "非公開"
      find(".learning-update-btn").click
      aggregate_failures do
        expect(current_path).to eq "/learnings/1"
        expect(page).to have_content "学習記録を更新しました"
        expect(page).to have_content "学習記録のタイトル更新"
        expect(page).to have_content "2021年02月01日"
        expect(page).to have_content "20.0時間"
        expect(page).to have_content "python"
        expect(page).to have_content "html"
        expect(page).to have_content "css"
      end
    end
  end
end
