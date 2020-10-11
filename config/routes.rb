Rails.application.routes.draw do
  root 'posts#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    get 'logout', to: 'users/sessions#destroy'
    get 'signup', to: 'users/registrations#new'
    post '/users/guest_login', to: 'users/sessions#new_guest'
  end

  resources :users, only: %i[index show] do
    member do
      get :posts, :comments, :following, :followers, :likes
    end
  end

  resources :posts do
    resources :comments, only: %i[create edit update destroy]
    resource :likes, only: %i[create destroy]
    member do
      get :liked_users
    end
    collection do
      get :novel, :business, :education, :art_ent, :celebrity, :hobby, :geography, :child, :others
    end
  end

  resources :following_posts, only: :index do
    collection do
      get :novel, :business, :education, :art_ent, :celebrity, :hobby, :geography, :child, :others
    end
  end

  resources :relationships, only: %i[create destroy]

  resources :notifications, only: :index
  delete 'notifications' => 'notifications#destroy_all'
end
