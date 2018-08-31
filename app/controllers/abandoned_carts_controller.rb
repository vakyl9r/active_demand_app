class AbandonedCartsController < ApplicationController
  include ShopifyApp::WebhookVerification

  before_action :set_abandoned_cart, only: [:update]
  respond_to :json

  def update
    enable = params[:enable]
    time = params[:time]
    form_id = params[:form_id]
    if @abandoned_cart.update(enable: params[:enable], time: params[:time], form_id: params[:form_id])
      render json: { abandoned_cart: @abandoned_cart}
    else
      render json: @abandoned_cart.errors
    end
  end

  def create_checkout
    params.permit!
    CheckoutsCreateJob.perform_later(shop_domain: shop_domain, webhook: webhook_params.to_h)
    @shop = Shop.find_by(shopify_domain: shop_domain)
    if @shop.abandoned_cart.enable
      if @shop.abandoned_cart.time
        session = ShopifyAPI::Session.new(shop_domain, @shop.shopify_token)
        binding.pry
        ShopifyAPI::Base.activate_session(session)
      end
    end
    head :no_content
  end

  private
  def set_abandoned_cart
    @abandoned_cart = AbandonedCart.find(params[:id])
  end

  def webhook_params
    params.except(:controller, :action, :type)
  end
end
