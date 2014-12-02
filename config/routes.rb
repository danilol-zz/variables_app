Rails.application.routes.draw do

  resources :users
  resources :origins
  resources :processids
  resources :tables
  resources :campaigns
  resources :variables
  resources :origin_fields

  get "user/index"
  root 'welcome#index'
  post "/signin"           => "users#authenticate"
  get  "/signup"           => "users#new"
  get  "/logout"           => "users#logout"
  get  "/password"         => "users#password"
  post "/password_update"  => "users#password_update"

  get  "/remember_password"          => "remember_password#index"
  get  "/remember_password/remember" => "remember_password#remember_password"
end
