Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # resources :pages, only: [ :dashboard ]
  get "dashboard", to: "pages#dashboard"


  # Task manager setup : Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin_config? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :invoices, only: [ :new, :create, :show ] do
    collection do
      get :received
      get :sent
    end

    member do
      patch :validate
      patch :decline_reason
      patch :send_to_partner
      patch :follow_up
      patch :pay
      patch :mark_as_paid
    end
    resources :companies, only: [:index]
  end
end
