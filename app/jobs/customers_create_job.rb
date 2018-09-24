class CustomersCreateJob < ActiveJob::Base
  require 'net/http'

  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    webhook_topic = 'customers/create'
    shop.with_shopify_session do
      forms = ActiveDemandWebhook.where(shop_id: shop.id, topic: webhook_topic)
      if forms
        parameters = { 'api-key': shop.adkey.key }
        forms.each do |form|
          uri = URI("https://api.activedemand.com/v1/forms/#{form.form_id}")
          uri.query = URI.encode_www_form(parameters )
          form_params = {}
          form.fields.each do |field|
            if field['webhook'] == 'id' || field['webhook'] == 'email' ||
              field['webhook'] == 'accepts_marketing' || field['webhook'] == 'created_at' ||
              field['webhook'] == 'updated_at' || field['webhook'] == 'first_name' ||
              field['webhook'] == 'last_name' ||  field['webhook'] == 'orders_count' ||
              field['webhook'] == 'state' || field['webhook'] == 'total_spent' ||
              field['webhook'] == 'last_order_id' || field['webhook'] == 'note' ||
              field['webhook'] == 'verified_email' || field['webhook'] == 'multipass_identifier' ||
              field['webhook'] == 'tax_exempt' || field['webhook'] == 'phone' ||
              field['webhook'] == 'tags' || field['webhook'] == 'last_order_name'
              form_params[:"#{field['ad']}"] = webhook[:"#{field['webhook']}"]
            else
              if webhook[:default_address]
                form_params[:"#{field['ad']}"] = webhook[:default_address][:"#{field['webhook']}"]
              end
            end
          end
          res = Net::HTTP.post_form(uri, form_params)
        end
      end
    end
  end
end
