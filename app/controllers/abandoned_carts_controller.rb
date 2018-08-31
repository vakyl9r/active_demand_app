class AbandonedCartsController < ApplicationController
  include ShopifyApp::WebhookVerification

  def create_checkout
    params.permit!
    CheckoutsCreateJob.perform_later(shop_domain: shop_domain, webhook: webhook_params.to_h)
    @shop = Shop.find_by(shopify_domain: shop_domain)
    if @shop.abandoned_cart.enable && @shop.abandoned_cart.form_id && @shop.abandoned_cart.time
      if @shop.abandoned_cart.time_parser == 'Days'
        time = @shop.abandoned_cart.time * 24
      else
        time = @shop.abandoned_cart.time
      end
      AbandonedCartJob.set(wait: time.minutes).perform_later(shop_domain: shop_domain, webhook: webhook_params.to_h, abandoned_cart: @shop.abandoned_cart )
    end
    head :no_content
  end

  private

  def webhook_params
    params.except(:controller, :action, :type)
  end
end
