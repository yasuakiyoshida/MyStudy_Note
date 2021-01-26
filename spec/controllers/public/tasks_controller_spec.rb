require "rails_helper"

RSpec.describe Public::TasksController, type: :controller do
  let(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }
  let(:tasks) { user.tasks }
  let(:another_user) { create(:user) }
  let(:another_task) { create(:task, user: another_user) }

  describe "GET #newのテスト" do
    context "ログイン済みの場合" do
      before do
        sign_in user
        get :new
      end

      it "ToDoリスト作成ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "ToDoリスト作成ページが描画されること" do
        expect(response).to render_template :new
      end
    end

    context "ログインしていない場合" do
      before do
        get :new
      end

      it "ToDoリスト作成ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #indexのテスト" do
    context "ログイン済みの場合" do
      before do
        sign_in user
        get :index
      end

      it "ToDoリスト一覧ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "ToDoリスト一覧ページが描画されること" do
        expect(response).to render_template :index
      end
      it "@tasksというインスタンス変数が正しく定義されていること" do
        expect(assigns(:tasks)).to eq tasks
      end
    end

    context "ログインしていない場合" do
      before do
        get :index
      end

      it "ToDoリスト一覧ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #showのテスト" do
    context "ログイン済みかつ、自分のToDoリストの場合" do
      before do
        sign_in user
        get :show, params: { id: task.id }
      end

      it "ToDoリスト詳細ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "ToDoリスト詳細ページが描画されること" do
        expect(response).to render_template :show
      end
      it "@taskというインスタンス変数が正しく定義されていること" do
        expect(assigns(:task)).to eq task
      end
    end

    context "ログイン済みかつ、他人のToDoリストの場合" do
      before do
        sign_in user
        get :show, params: { id: another_task.id }
      end

      it "ToDoリスト詳細ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "トップページにリダイレクトされること" do
        expect(response).to redirect_to root_path
      end
    end

    context "ログインしていない場合" do
      before do
        get :show, params: { id: task.id }
      end

      it "ToDoリスト詳細ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #editのテスト" do
    context "ログイン済みの場合" do
      before do
        sign_in user
        get :edit, params: { id: task.id }
      end

      it "自分のToDoリスト編集ページへのリクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "自分のToDoリスト編集ページが描画されること" do
        expect(response).to render_template :edit
      end
      it "@taskというインスタンス変数が正しく定義されていること" do
        expect(assigns(:task)).to eq task
      end
    end

    context "ログインしていない場合" do
      before do
        get :edit, params: { id: task.id }
      end

      it "ToDoリスト編集ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "他人のToDoリスト編集ページの場合" do
      before do
        sign_in user
        get :edit, params: { id: another_task.id }
      end

      it "他人の学習記録の編集ページへのリクエストは302 リダイレクトとなること" do
        expect(response.status).to eq 302
      end
      it "トップページにリダイレクトされること" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST #createのテスト" do
    context "ログインしていて、かつ保存に成功した場合" do
      before do
        sign_in user
      end

      it "ToDoリストがデータベースに保存されること" do
        expect do
          post :create, params: { task: attributes_for(:task) }
        end.to change(user.tasks, :count).by(1)
      end
      it "保存後、保存したToDoリスト詳細ページにリダイレクトされること" do
        post :create, params: { task: attributes_for(:task) }
        expect(response).to redirect_to Task.last
      end
    end

    context "ログインしていて、かつ保存に失敗した場合" do
      before do
        sign_in user
      end

      it "ToDoリストがデータベースに保存されないこと" do
        expect do
          post :create, params: { task: attributes_for(:task, title: nil) }
        end.to change(user.tasks, :count).by(0)
      end
      it "newテンプレートが表示されること" do
        post :create, params: { task: attributes_for(:task, title: nil) }
        expect(response).to render_template :new
      end
    end

    context "ログインしていない場合" do
      before do
        post :create, params: { task: attributes_for(:task, title: nil) }
      end

      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH #updateのテスト" do
    context "自分のToDoリストであり、かつパラメータが妥当な場合" do
      before do
        sign_in user
        task_params = { title: "タイトル変更" }
        patch :update, params: { id: task.id, task: task_params }
      end

      it "ToDoリストが更新されること" do
        expect(task.reload.title).to eq "タイトル変更"
      end
      it "更新後、更新したToDoリスト詳細ページにリダイレクトされること" do
        expect(response).to redirect_to task_path(task)
      end
      it "@taskというインスタンス変数が正しく定義されていること" do
        expect(assigns(:task)).to eq task
      end
    end

    context "自分のToDoリストであり、かつパラメータが不正な場合" do
      before do
        sign_in user
        task_params = { title: nil }
        patch :update, params: { id: task.id, task: task_params }
      end

      it "ToDoリストが更新されないこと" do
        expect(task.reload.title).to eq "ToDoリストのタイトル"
      end
      it "editテンプレートが表示されること" do
        expect(response).to render_template :edit
      end
    end

    context "他のユーザーのToDoリストを編集しようとする場合" do
      before do
        sign_in user
        another_task_params = { title: "タイトル変更" }
        patch :update, params: { id: another_task.id, task: another_task_params }
      end

      it "ToDoリストが更新されないこと" do
        expect(another_task.reload.title).not_to eq "タイトル変更"
      end
      it "トップページにリダイレクトされること" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "DELETE #destroyのテスト" do
    before do
      sign_in user
    end

    it "ToDoリストが削除されること" do
      expect do
        delete :destroy, params: { id: task }
      end.to change(user.tasks, :count).by(-1)
    end
    it "削除後、ToDoリスト一覧ページにリダイレクトされること" do
      delete :destroy, params: { id: task }
      expect(response).to redirect_to tasks_path
    end
  end
end
