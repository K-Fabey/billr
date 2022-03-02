Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

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
  end
end
