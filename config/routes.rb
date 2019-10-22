Rails.application.routes.draw do
  root to: 'igposts#index'

  get 'policy', to: "static_pages#policy"

  devise_for :users, skip: [:sessions, :registrations, :signups], controllers: {
    # 編集するコントローラーを以下に記載
    # registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations_controller'
  }

  devise_scope :user do
    get "signup", to: "users/registrations#new", as: :new_user_registration
    post "signup", to: "users/registrations#create", as: :user_registration
    # プロフィール変更
    get "users/edit_profile", to: "users/registrations#edit_profile", as: :edit_profile
    patch "users/update_profile", to: "users/registrations#update_profile", as: :update_profile
    # パスワード変更
    get "users/edit", to: "users/registrations#edit", as: :edit_user_registration
    patch "users", to: "users/registrations#update", as: nil
    # ユーザー削除
    # delete 'users' => 'users/registrations#destroy', as: :destroy_user_registration
    get "login", to: "users/sessions#new", as: :new_user_session
    post "login", to: "users/sessions#create", as: :user_session
    delete "logout", to: "users/sessions#destroy", as: :destroy_user_session
  end

  resources :users, only:[:show, :destroy] do
    resource :relationships, only: [:create, :destroy]
    get :follows, on: :member # ex) /users/2/follows = user2のフォロー一覧
    get :followers, on: :member # ex) /users/2/followers = user2のフォロワー一覧
  end

  resources :igposts do
    resource :favorites, only: [:create, :destroy]
    resource :comments, only: [:create, :destroy]
    get :detail, on: :member
  end

  resources :notifications, only: :index

  get "search", to: "igposts#search"
end
