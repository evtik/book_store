Rails.application.routes.draw do
  root to: 'home#index'
  get 'home/index'
  get 'catalog/index'

  resources :books, only: :show

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }#, path_names: { sign_in: 'login', sign_up: 'logout' }

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'logout', to: 'devise/sessions#destroy'
  end

  # devise_scope :user do
    # get 'login', to: 'devise/sessions#new'

    # authenticated :user do
      # root to: 'admin/dashboard#index', as: :authenticated_root
    # end

    # unauthenticated :user do
      # root to: 'users/sessions#new', as: :unauthenticated_root
    # end
  # end

  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/cart', to: 'cart#index'
  post '/cart/add_item', to: 'cart#add_item', as: :add_item
  post '/cart/update_quantity', to: 'cart#update_quantity', as: :update_item_quantity
  delete '/cart/remove_item/:id', to: 'cart#remove_item', as: :remove_item
end
