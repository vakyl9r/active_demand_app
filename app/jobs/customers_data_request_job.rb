class CustomersDataRequestJob < ApplicationJob
  require 'net/http'
  queue_as :default

  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    shop.with_shopify_session do
      parameters = { 'api-key': shop.adkey.key }
      uri_contacts = URI("https://api.activedemand.com/v1/contacts.json")
      uri_contacts.query = URI.encode_www_form(parameters )
      res_contacts = Net::HTTP.get_response(uri_contacts)
      email = webhook[:customer][:email]
      if res_contacts.is_a?(Net::HTTPSuccess)
        uri = URI("https://#{shop_domain}/admin/shop.json")
        res = Net::HTTP.get_response(uri)
        contacts = JSON[res_contacts.body]
        ad_contact = contacts.detect{|contact| contact['emails.email_address'] == email}
        if ad_contact
          p 'Send information about this email'
          p ad_contact['emails.email_address']
        end
        #if res.is_a?(Net::HTTPSuccess)
          #res_contacts.body.each do |contact|
            #binding.pry
            #p contact
          #end
        #else
          #render json: { errors: res.body }, status: 409
        #end
      else
        render json: { errors: res_contacts.body }, status: 409
      end
    end
  end
end
