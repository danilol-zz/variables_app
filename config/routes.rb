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

  get  "/remember_password/:id" => "users#remember_password_index", :as => "remember"
  post "/remember_password"     => "users#remember_password"
end
