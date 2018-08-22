class ActiveDemandWebhooksController < ApplicationController
  before_action :set_active_demand_webhook, only: [:update, :destroy]
  respond_to :json
  require 'net/http'

  def all_ad_webhooks
    shop = Shop.find(params[:shop_id])
    @active_demand_webhooks = shop.active_demand_webhooks
    @webhooks = WebhookName.all
    uri = URI('https://api.activedemand.com/v1/forms.json')
    parameters = { 'api-key': shop.adkey.key }
    uri.query = URI.encode_www_form(parameters )
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      render json: { ad_webhooks: @active_demand_webhooks, forms: res.body,
         webhooks: @webhooks }
    else
      render json: { errors: res.body }, status: 409
    end
  end

  def create
    @active_demand_webhook = ActiveDemandWebhook.new(shop_id: params[:shop_id])
    shop = Shop.find(params[:shop_id])
    uri = URI('https://api.activedemand.com/v1/forms.json')
    parameters = { 'api-key': shop.adkey.key }
    uri.query = URI.encode_www_form(parameters )
    res = Net::HTTP.get_response(uri)
    @webhooks = WebhookName.all
    if @active_demand_webhook.save
      render json: { ad_webhook: @active_demand_webhook, forms: res.body,
         webhooks: @webhooks }
    else
      render json: { errors: @active_demand_webhook.errors }
    end
  end

  def update
    activedemand_array = params[:activedemand_array]
    shopify_array = params[:shopify_array]
    webhook_topic = params[:webhook_topic]
    form_id = params[:form_id]
    @adw_params = []
    shopify_array.each_with_index do |webhook, index|
      if !webhook.blank?
        webhook_field = webhook.remove(' ').tableize.singularize
        @adw_params.push "#{activedemand_array[index]}": webhook_field
      end
    end
    if @active_demand_webhook.update(topic: webhook_topic, fields: @adw_params,
    form_id: form_id)
      render json: { webhook: @active_demand_webhook}
    else
      render json: @active_demand_webhook.errors
    end
  end

  def destroy
    @active_demand_webhook.destroy
    render json: { webhook: @active_demand_webhook}
  end

  private
    def set_active_demand_webhook
      @active_demand_webhook = ActiveDemandWebhook.find(params[:id])
    end
end
