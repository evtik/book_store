Rails.application.routes.draw do
  root to: 'home#index'
  get 'home/index'
  get 'catalog/index'

  resources :books, only: :show
  # scope 'user' do
    # resources :orders, only: [:index, :show]
  # end

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

  scope '/admin/aasm', module: :admin do
    resources :orders, only: [:queue, :deliver, :complete, :cancel] do
      put :queue
      put :deliver
      put :complete
      put :cancel
    end

    resources :reviews, only: [:approve, :reject] do
      put :approve
      put :reject
    end
  end

  get '/cart', to: 'cart#index'
  post '/cart/add', to: 'cart#add', as: :cart_add
  post '/cart/update', to: 'cart#update', as: :cart_update
  delete '/cart/remove/:id', to: 'cart#remove', as: :cart_remove

  %w(address delivery payment confirm).each do |action|
    get "/checkout/#{action}", to: "checkout##{action}"
    post "/checkout/#{action}", to: "checkout#submit_#{action}"
  end
  get '/checkout/complete', to: 'checkout#complete'

  get '/user/:id/orders', to: 'orders#index', as: :user_orders
  get '/user/:id/orders/:order_id', to: 'orders#show', as: :user_order

  get '/user/:id/settings', to: 'user_settings#show', as: :user_settings
  post '/user/:id/settings/', to: 'user_settings#update_address',
                              as: :user_settings_update_address
  patch '/user/:id/settings/email', to: 'user_settings#update_email',
                                   as: :user_settings_update_email
end
