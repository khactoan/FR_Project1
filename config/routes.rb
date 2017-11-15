Rails.application.routes.draw do
  root "posts#index"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "sessions/new"
  get "/user/following", to: "user#following"
  get "/user/followers", to: "user#followers"

  resources :comments
  resources :posts
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :relationships, only: %i(create destroy)
end
