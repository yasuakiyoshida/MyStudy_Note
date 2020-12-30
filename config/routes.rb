Rails.application.routes.draw do
  devise_for :users
  
  scope module: :public do
    root 'homes#top'
    get '/about' => 'homes#about'
    resources :users, only: [:index, :show, :edit, :update] do
      get 'learning_times' => 'learning_times#index'
    end
    resources :learnings do
      resources :learning_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    resources :tasks
    resources :task_progresses, only: [:update]
  end
end
