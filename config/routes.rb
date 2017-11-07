Rails.application.routes.draw do
  resources :posts
  resources :users

  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "sessions/new"
  root "sessions#new"
end
