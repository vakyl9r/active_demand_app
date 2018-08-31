class Shop < ActiveRecord::Base
  include ShopifyApp::SessionStorage
  has_many :active_demand_webhooks
  has_one :adkey
  has_one :abandoned_cart
end
