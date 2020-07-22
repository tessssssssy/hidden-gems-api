Rails.application.routes.draw do
  post "/sign-up", to: "users#create"
  post "/login", to: "user_token#create"
  get "/status", to: "status#index"
  get "/status/user", to: "status#user"
  resources :locations do
    resources :comments, except: :show
    resources :ratings, only: :create
  end
end
