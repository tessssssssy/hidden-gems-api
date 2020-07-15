Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "/login", to: "user_token#create"
  get "/status", to: "status#index"
  get "/status/user", to: "status#user"
  resources :locations
end
