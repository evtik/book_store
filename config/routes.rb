Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'logout', to: 'devise/sessions#destroy'
  end

  ActiveAdmin.routes(self)

  scope '/admin/aasm', module: :admin do
    order_events = [:queue, :deliver, :complete, :cancel]
    resources :orders, only: order_events do
      order_events.each { |event| put event }
    end

    review_events = [:approve, :reject]
    resources :reviews, only: review_events do
      review_events.each { |event| put event }
    end
  end

  get 'home/index'
  get 'catalog/index'

  resources :books, only: :show do
    resources :reviews, only: [:new, :create]
  end

  resource :cart, only: [:show, :update]
  resources :cart_items, only: [:create, :destroy]

  scope 'checkout' do
    %w(address delivery payment confirm).each do |action|
      get action, to: "checkout##{action}", as: "checkout_#{action}"
      post action, to: "checkout#submit_#{action}",
                   as: "checkout_submit_#{action}"
    end
    get 'complete', to: 'checkout#complete', as: :checkout_complete
  end

  scope 'user' do
    get ':id/orders', to: 'orders#index', as: :user_orders
    get ':id/orders/:order_id', to: 'orders#show', as: :user_order

    get ':id/settings', to: 'user_settings#show', as: :user_settings
    post ':id/settings', to: 'user_settings#update_address',
                         as: :user_settings_update_address
    patch ':id/settings/email', to: 'user_settings#update_email',
                                as: :user_settings_update_email
  end
end
