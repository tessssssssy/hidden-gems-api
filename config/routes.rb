Rails.application.routes.draw do
  post "/sign-up", to: "users#create"
  post "/login", to: "user_token#create"
  get "/status", to: "status#index"
  get "/status/user", to: "status#user"
  resources :locations do
    resources :comments
    resources :ratings, only: :create
  end
end
