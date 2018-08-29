class CustomersUpdateJob < ActiveJob::Base
  require 'net/http'

  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    webhook_topic = 'customers/update'
    shop.with_shopify_session do
      forms = ActiveDemandWebhook.where(shop_id: shop.id, topic: webhook_topic)
      if forms
        parameters = { 'api-key': shop.adkey.key }
        forms.each do |form|
          uri = URI("https://api.activedemand.com/v1/forms/#{form.form_id}")
          uri.query = URI.encode_www_form(parameters )
          form_params = {}
          form.fields.each do |field|
            if field['webhook'] == 'email' || field['webhook'] == 'note' || field['webhook'] == 'first_name' || field['webhook'] == 'last_name' || field['webhook'] == 'phone'
              form_params[:"#{field['ad']}"] = webhook[:"#{field['webhook']}"]
            else
              if  webhook[:default_address]
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
