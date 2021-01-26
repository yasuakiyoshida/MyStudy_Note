Rails.application.routes.draw do
  devise_for :admins, skip: :all
  devise_scope :admin do
    get 'admins/sign_in' => 'admins/sessions#new', as: :new_admin_session
    post 'admins/sign_in' => 'admins/sessions#create', as: :admin_session
    delete 'admins/sign_out' => 'admins/sessions#destroy', as: :destroy_admin_session
  end

  devise_for :users, skip: :all
  devise_scope :user do
    get 'password' => 'public/passwords#new'
    get 'sign_in' => 'public/sessions#new', as: :new_user_session
    post 'sign_in' => 'public/sessions#create', as: :user_session
    delete 'sign_out' => 'public/sessions#destroy', as: :destroy_user_session
    get 'password/new' => 'public/passwords#new', as: :new_user_password
    get 'password/edit' => 'public/passwords#edit', as: :edit_user_password
    patch 'password' => 'public/passwords#update'
    put 'password' => 'public/passwords#update'
    post 'password' => 'public/passwords#create', as: :user_password
    get 'sign_up' => 'public/registrations#new', as: :new_user_registration
    post 'sign_up' => 'public/registrations#create', as: :user_registration
  end

  scope module: :public do
    root 'homes#top'
    get 'common_learnings' => 'homes#common_learnings'
    get 'common_learnings/search' => 'homes#search', as: :search_common_learnings
    resources :users, only: [:index, :show, :edit, :update] do
      get 'learning_times' => 'learning_times#index'
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
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
