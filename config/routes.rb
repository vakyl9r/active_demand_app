Rails.application.routes.draw do
  resources :adkeys, only: :update

  resources :active_demand_webhooks, only: [:create, :update, :destroy]
  post 'active_demand_api_key_verification', to: 'adkeys#active_demand_api_key_verification'
  post 'get_fields', to: 'adkeys#get_fields'
  post 'get_fields_abandoned_cart', to:'adkeys#get_fields_abandoned_cart'

  patch 'save_adfields_abandoned_cart/:id', to: 'adkeys#save_adfields_abandoned_cart'
  post 'all_ad_webhooks', to: 'active_demand_webhooks#all_ad_webhooks'
  patch 'update_abandoned_cart/:id', to: 'adkeys#update_abandoned_cart'
  post '/abandoned_carts/create_checkout', to: 'abandoned_carts#create_checkout'

  post 'customers/redact', to: 'gdpr_webhooks#customers_redact'
  post 'shop/redact', to: 'gdpr_webhooks#shop_redact'
  post 'customers/data_request', to: 'gdpr_webhooks#customers_data_request'

  root to: 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
