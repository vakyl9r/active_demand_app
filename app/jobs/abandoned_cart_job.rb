class AbandonedCartJob < ActiveJob::Base
  def perform(shop_domain:, webhook:, abandoned_cart:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    shop.with_shopify_session do
      unless ShopifyAPI::Order.where(checkout_token: webhook[:token])
        if webhook[:email] && webhook[:shipping_address]
          parameters = { 'api-key': shop.adkey.key }
          uri = URI("https://api.activedemand.com/v1/forms/#{abandoned_cart.form_id}")
          uri.query = URI.encode_www_form(parameters )
          form_params = {}
          abandoned_cart.ad_fields.each do |field|
            if field['webhook'].include?('customer_') && webhook[:customer].present?
              webhook_field = field['webhook'].remove('customer_')
              form_params[:"#{field['ad']}"] = webhook[:customer][:"#{webhook_field}"]
            elsif field['webhook'] == 'email' || field['webhook'] == 'id' ||
              field['webhook'] == 'total_price' || field['webhook'] == 'subtotal_price' ||
              field['webhook'] == 'abandoned_checkout_url' || field['webhook'] == 'line_items'
              form_params[:"#{field['ad']}"] = webhook[:"#{field['webhook']}"]
            else
              if webhook[:shipping_address].present?
                form_params[:"#{field['ad']}"] = webhook[:shipping_address][:"#{field['webhook']}"]
              end
            end
          end
          res = Net::HTTP.post_form(uri, form_params)
        end
      end
    end
  end
end
