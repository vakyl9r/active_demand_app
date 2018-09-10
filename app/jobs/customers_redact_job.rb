class CustomersRedactJob < ApplicationJob
  require 'net/http'
  queue_as :default

  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    email = webhook[:customer][:email]
    shop.with_shopify_session do
      parameters_post = { 'api-key': shop.adkey.key }
      uri_post = URI("https://api.activedemand.com/v1/contacts/forget.json")
      uri_post.query = URI.encode_www_form(parameters_post)
      form_params = {}
      form_params[:'email_address'] = email
      res_post = Net::HTTP.post_form(uri_post, form_params)

      p 'Customer redact webhook completed'
    end
  end
end
