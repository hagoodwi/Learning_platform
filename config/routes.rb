Rails.application.routes.draw do
  # get 'static_pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_for :users, controllers: { registrations: 'users/registrations'}

  resources :disciplines do
    resources :materials, only: [:new, :create, :index, :show] do
      member do
        patch 'update_access', to: 'materials#update_access', as: :update_access
      end
    end  
    member do
      delete 'detach_material/:material_id', to: 'disciplines#detach_material', as: :detach_material
    end
  end
  resources :schedules do
    get 'load_disciplines', on: :collection
    get 'carousel', on: :member
  end
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

  namespace :moderator do
    resources :courses do
      member do
        get 'teachers' => 'courses#edit_teachers'
        patch 'teachers' => 'courses#update_teachers'
        get 'students' => 'courses#edit_students'
        patch 'students' => 'courses#update_students'
        get 'disciplines' => 'courses#edit_disciplines'
        patch 'disciplines' => 'courses#update_disciplines'
      end
    end
    resources :disciplines do
      resources :materials, only: [:new, :create, :show, :index]
      member do
        post 'attach_materials', to: 'disciplines#attach_materials', as: :attach_materials
        delete 'detach_material/:material_id', to: 'disciplines#detach_material', as: :detach_material
        post 'update_order', to: 'disciplines#update_order', as: :update_order
      end
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