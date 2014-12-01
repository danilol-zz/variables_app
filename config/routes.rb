Rails.application.routes.draw do
  get "user/index"

  root 'welcome#index'
  resources :variables
  resources :users
  resources :origin_fields
  resources :origins

  post "/signin"           => "users#authenticate"
  get  "/signup"           => "users#new"
  get  "/logout"           => "users#logout"
  get  "/password"         => "users#password"
  get  "/password_update"  => "users#password_update"

  get  "/remember_password"          => "remember_password#index"
  get  "/remember_password/remember" => "remember_password#remember_password"
end
