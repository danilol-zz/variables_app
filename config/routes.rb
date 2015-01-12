Rails.application.routes.draw do

  root 'welcome#index'

  resources :users, :origins, :origin_fields, :processids, :tables, :campaigns, :variables


  post "index" => "welcome#index"
  get  "index" => "welcome#index"

  post "/create_or_update_origin_field" => "origins#create_or_update_origin_field"
  get "/get_origin_field_to_update"     => "origins#get_origin_field_to_update"
  delete "/destroy_origin_field"        => "origins#destroy_origin_field"

  post "/create_origin_field_upload" => "origins#create_origin_field_upload"

  match '/export_script', to: 'scripts#index', via: [:get, :post]

  get "user/index"
  get "/login"             => "users#login"
  post "/signin"           => "users#authenticate"
  get  "/signup"           => "users#new"
  get  "/logout"           => "users#logout"
  get  "/password"         => "users#password"
  post "/password_update"  => "users#password_update"

  get  "/remember_password/:id" => "users#remember_password_index", :as => "remember"
  post "/remember_password"     => "users#remember_password"

  post "/search/origin"   => "origins#search",   :as => "search_origin"
  post "/search/campaign" => "campaigns#search", :as => "search_campaign"
  post "/search/table"    => "tables#search",    :as => "search_table"
end
