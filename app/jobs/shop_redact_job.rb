class ShopRedactJob < ApplicationJob
  require 'net/http'
  queue_as :default

  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    shop.with_shopify_session do
      parameters = { 'api-key': shop.adkey.key }
      uri = URI("https://api.activedemand.com/v1/cancel_account.json")
      uri.query = URI.encode_www_form(parameters )
      form_params = {}
      res = Net::HTTP.post_form(uri, form_params)
      p 'Shop redact webhook completed'
    end
  end
end
