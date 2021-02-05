require "rails_helper"

RSpec.describe Public::TasksController, type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe "GET #index" do
    context "ログイン済みの場合" do
      before do
        create(:task_one, user: user)
        create(:task_second, user: user)
        sign_in user
        get tasks_url
      end

      it "リクエストは200 OK" do
        expect(response.status).to eq 200
      end
      it "ToDoリストの題名が表示されること" do
        expect(response.body).to include "一番目のリストのタイトル"
        expect(response.body).to include "二番目のリストのタイトル"
      end
    end

    context "ログインしていない場合" do
      before do
        get tasks_url
      end

      it "リクエストは302 リダイレクト" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "GET #show" do
    context "ログイン済みかつ自分のToDoリストの場合" do
      let(:task_one) { create(:task_one, user: user) }

      before do
        sign_in user
        get task_url task_one.id
      end

      it "リクエストは200 OK" do
        expect(response.status).to eq 200
      end
      it "ToDoリストの題名と詳細が表示されること" do
        expect(response.body).to include "一番目のリストのタイトル"
        expect(response.body).to include "一番目のリストの詳細"
      end
    end

    context "ログイン済みかつ他人のToDoリストの場合" do
      let(:task_one) { create(:task_one, user: another_user) }

      before do
        sign_in user
        get task_url task_one.id
      end

      it "リクエストは302 リダイレクト" do
        expect(response.status).to eq 302
      end
      it "トップページにリダイレクトされること" do
        expect(response).to redirect_to root_url
      end
    end

    context "ログインしていない場合" do
      let(:task_one) { create(:task_one, user: user) }

      before do
        get task_url task_one.id
      end

      it "リクエストは302 リダイレクト" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "POST #create" do
    context "ログイン済みかつ保存に成功した場合" do
      before do
        sign_in user
      end

      it "ToDoリストがデータベースに保存されること" do
        expect do
          post tasks_url, params: { task: attributes_for(:task, user: user) }
        end.to change(user.tasks, :count).by(1)
      end
      it "保存後、保存したToDoリスト詳細ページにリダイレクトされること" do
        post tasks_url, params: { task: attributes_for(:task, user: user) }
        expect(response).to redirect_to Task.last
      end
    end

    context "ログインしていない場合" do
      before do
        post tasks_url, params: { task: attributes_for(:task, user: user) }
      end

      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "PATCH #update" do
    context "自分のToDoリストであり、かつパラメータが妥当な場合" do
      let(:task_one) { create(:task_one, user: user) }

      before do
        sign_in user
      end

      it "リクエストは302 リダイレクト" do
        patch task_url task_one, params: { task: attributes_for(:task_second) }
        expect(response.status).to eq 302
      end
      it "ToDoリストの題名が更新されること" do
        expect do
          patch task_url task_one, params: { task: attributes_for(:task_second) }
        end.to change { Task.find(task_one.id).title }.from("一番目のリストのタイトル").to("二番目のリストのタイトル")
      end
      it "更新後、更新したToDoリスト詳細ページにリダイレクトされること" do
        patch task_url task_one, params: { task: attributes_for(:task_second) }
        expect(response).to redirect_to(task_url(task_one))
      end
    end

    context "他のユーザーのToDoリストを編集しようとする場合" do
      let(:task_one) { create(:task_one, user: another_user) }

      before do
        sign_in user
      end

      it "ToDoリストの題名が更新されないこと" do
        expect do
          patch task_url task_one, params: { task: attributes_for(:task_second) }
        end.not_to change(Task.find(task_one.id), :title)
      end
      it "トップページにリダイレクトされること" do
        patch task_url task_one, params: { task: attributes_for(:task_second) }
        expect(response).to redirect_to root_url
      end
    end
  end
end
