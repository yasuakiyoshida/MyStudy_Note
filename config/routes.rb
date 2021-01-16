Rails.application.routes.draw do
  devise_for :admins
  
  devise_for :users, controllers: {
    sessions: 'public/sessions',
    registrations: 'public/registrations',
    passwords: 'public/passwords'
  }
  
  scope module: :public do
    root 'homes#top'
    resources :users, only: [:index, :show, :edit, :update] do
      get 'learning_times' => 'learning_times#index'
      get :search, on: :collection
    end
    resources :learnings do
      get :search, on: :collection
      resources :learning_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    resources :tasks do
      get :search, on: :collection
    end
  end
  
  namespace :admins do
    resources :users, except: [:new, :create] do
      get :search, on: :collection
    end
    resources :learnings, except: [:new, :create] do
      get :search, on: :collection
      resources :learning_comments, only: [:destroy]
    end
  end
end