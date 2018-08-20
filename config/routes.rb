Rails.application.routes.draw do
  resources :adkeys, only: :update
  post 'active_demand_api_key_verification', to: 'adkeys#active_demand_api_key_verification'
  post 'get_fields', to: 'adkeys#get_fields'
  root to: 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
