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
            uri = URI("https://api.activedemand.com/v1/forms/#{form.id}")
            uri.query = URI.encode_www_form(parameters )
            form_params = {}
            form.fields.each do |field|
              if field['webhook'] == 'email'
                form_params[:"#{field['ad']}"] = webhook[:"#{field['webhook']}"]
              else
                form_params[:"#{field['ad']}"] = webhook[:shipping_address][:"#{field['webhook']}"]
              end
            end
            res = Net::HTTP.post_form(uri, form_params)
          end
        end
      end
    end
  end
end
