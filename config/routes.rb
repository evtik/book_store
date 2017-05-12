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
  post '/cart/add', to: 'cart#add', as: :cart_add
  post '/cart/update', to: 'cart#update', as: :cart_update
  delete '/cart/remove/:id', to: 'cart#remove', as: :cart_remove

  # resources :checkout
  get '/checkout/address', to: 'checkout#address'
  post '/checkout/address', to: 'checkout#submit_address'
  get '/checkout/delivery', to: 'checkout#delivery'
  post '/checkout/delivery', to: 'checkout#submit_delivery'
  get '/checkout/payment', to: 'checkout#payment'
  post '/checkout/payment', to: 'checkout#submit_payment'
  get '/checkout/confirm', to: 'checkout#confirm'
  post '/checkout/confirm', to: 'checkout#submit_confirm'
  get '/checkout/complete', to: 'checkout#complete'
end
