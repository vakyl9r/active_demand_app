class CustomersRedactJob < ApplicationJob
  queue_as :default

  def perform(webhook)
    @shop = Shop.find_by(shopify_domain: webhook.shop_domain)
    @collected_email = @shop.collected_emails.find_by(email: webhook.customer.email)
    @collected_email.destroy
  end
end
