Rails.application.routes.draw do
  root 'top_pages#index'
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'   
  } 

  devise_scope :user do
    get "login", :to => "users/sessions#new"
    get "logout", :to => "users/sessions#destroy" 
    get "signup", :to => "users/registrations#new"
  end

  resources :users, only: [:index, :show] do
    member do
      get :following, :followers
    end
  end
  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
    resource :likes, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]

end
