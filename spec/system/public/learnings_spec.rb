require "rails_helper"

RSpec.describe "learning作成と詳細画面、編集画面", type: :system do
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
  end
end
