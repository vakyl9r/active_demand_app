class ShopRedactJob < ApplicationJob
  require 'net/http'
  queue_as :default

  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    shop.with_shopify_session do
      p 'Shop redact webhook'
    end
  end
end
