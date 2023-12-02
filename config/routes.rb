Rails.application.routes.draw do
  # get 'static_pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_for :users, controllers: { registrations: 'users/registrations'}


  resources :users, only: [:edit, :update, :show]
  resources :groups
  resources :courses do
    member do
      get 'teachers' => 'courses#edit_teachers'
      patch 'teachers' => 'courses#update_teachers'
      get 'students' => 'courses#edit_students'
      patch 'students' => 'courses#update_students'
    end
  end

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update] do
      # member do
      #   patch 'toggle_block' => 'users#toggle_block'
      # end
    end
    root "users#index"
    resources :roles
    resources :groups
  end

  root "static_pages#home"
end
