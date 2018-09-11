class GdprWebhooksController < ApplicationController
  include ShopifyApp::WebhookVerification

  def customers_redact
    params.permit!
    CustomersRedactJob.perform_later(webhook: webhook_params.to_h)
    head :ok
  end

  def shop_redact
    params.permit!
    ShopRedactJob.perform_later(webhook: webhook_params.to_h)
    head :ok
  end

  def customers_data_request
    params.permit!
    CustomersDataRequestJob.perform_later(shop_domain: shop_domain, webhook: webhook_params.to_h)
    head :ok
  end

  private

  def webhook_params
    params.except(:controller, :action, :type)
  end
end
