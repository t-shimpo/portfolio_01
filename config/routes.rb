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

  resources :users, only: [:index, :show]

end
