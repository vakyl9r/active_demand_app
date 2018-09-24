class CheckoutsCreateJob < ActiveJob::Base
  require 'net/http'

  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    webhook_topic = 'checkouts/create'
    shop.with_shopify_session do
      if webhook[:email] && webhook[:shipping_address]
        forms = ActiveDemandWebhook.where(shop_id: shop.id, topic: webhook_topic)
        if forms
          parameters = { 'api-key': shop.adkey.key }
          forms.each do |form|
            uri = URI("https://api.activedemand.com/v1/forms/#{form.form_id}")
            uri.query = URI.encode_www_form(parameters )
            form_params = {}
            form.fields.each do |field|
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
end
