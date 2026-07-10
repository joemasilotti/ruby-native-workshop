Rails.application.routes.draw do
  resource  :session
  resources :passwords, param: :token
  resource  :registration, only: [ :new, :create ]
  root "dashboard#show"
  get "summary",  to: "summary#show"
  get "settings", to: "settings#show"
  resources :expenses, only: [ :new, :create, :edit, :update, :destroy ]
  resources :categories, except: [ :show ]
  resource :profile, only: [ :edit, :update ]
  get "qr", to: "qr#show"
  get "up" => "rails/health#show", as: :rails_health_check
end
