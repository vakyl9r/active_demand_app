Rails.application.routes.draw do
  resources :adkeys, only: :update

  resources :active_demand_webhooks, only: [:create, :update, :destroy]
  post 'active_demand_api_key_verification', to: 'adkeys#active_demand_api_key_verification'
  post 'get_fields', to: 'adkeys#get_fields'
  post 'save_adfields', to: 'adkeys#save_adfields'
  post 'all_ad_webhooks', to: 'active_demand_webhooks#all_ad_webhooks'
  resources :abandoned_carts, only: :update
  post '/abandoned_carts/create_checkout', to: 'abandoned_carts#create_checkout'

  root to: 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
