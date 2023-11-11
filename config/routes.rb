Rails.application.routes.draw do
  # get 'static_pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_for :users, controllers: { registrations: 'users/registrations'}
  # resources :groups
  root "static_pages#home"

  resources :groups do
    member do
      get 'show_users'
      post 'add_user'
      post 'add_users'
      patch 'update_users'
    end
  end
end
