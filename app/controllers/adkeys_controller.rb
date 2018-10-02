class AdkeysController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :set_adkey, only: [:show, :edit, :update, :destroy]
  before_action :set_abandoned_cart, only: [:update_abandoned_cart, :save_adfields_abandoned_cart]
  respond_to :js, :html, :json
  require 'net/http'

  def update_abandoned_cart
    enable = params[:enable]
    time = params[:time]
    form_id = params[:form_id]
    time_parser = params[:time_parser]
    if @abandoned_cart.update(enable: enable, time: time, form_id: form_id, time_parser: time_parser )
      render json: { abandoned_cart: @abandoned_cart}
    else
      render json: @abandoned_cart.errors
    end
  end

  def create
    @adkey = Adkey.new(adkey_params)

    respond_to do |format|
      if @adkey.save
        format.html { redirect_to root_path, notice: 'Api Key was successfully saved.' }
        format.json { render :show, status: :created, location: @adley }
      else
        format.html { render :new }
        format.json { render json: @adkey.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      uri = URI('https://api.activedemand.com/v1/script_url')
      parameters = {'api-key': params[:adkey][:key]}
      uri.query = URI.encode_www_form(parameters )
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess)
        if @adkey.update(key: params[:adkey][:key], script_url: res.body)
          format.html { redirect_to root_path, notice: 'Api Key was successfully updated.' }
        else
          format.html { redirect_to root_path, notice: 'Error has occured while updating Api Key.' }
        end
      else
        format.html { redirect_to root_path, notice: 'There has been an error with ActiveDEMAND API please try again later' }
      end
    end
  end

  def destroy
    @adkey.destroy
    respond_with(@adkey)
  end

  def active_demand_api_key_verification
    uri = URI('https://api.activedemand.com/v1/forms.json')
    uri2 = URI('https://api.activedemand.com/v1/smart_blocks.json')
    parameters = { 'api-key': params[:key] }
    uri.query = URI.encode_www_form(parameters )
    uri2.query = URI.encode_www_form(parameters )
    res = Net::HTTP.get_response(uri)
    res2 = Net::HTTP.get_response(uri2)
    @shopify_webhooks = WebhookName.all
    @abandoned_cart = AbandonedCart.find_by(shop_id: params[:shop_id])
    if res.is_a?(Net::HTTPSuccess)
      render json: { data_forms: res.body, data_blocks: res2.body, key: params[:key], data_webhooks: @shopify_webhooks, data_abandoned_cart: @abandoned_cart }
    else
      render json: { errors: res.body }, status: 409
    end
  end

  def get_fields
    webhook_topic = params[:webhook_topic]
    @webhook = WebhookName.find_by(topic: webhook_topic)
    @ad_webhook = ActiveDemandWebhook.find(params[:webhook_id])
    @webhook_columns = []
    @webhook.fields.each do |column_name|
      @webhook_columns.push key: column_name, humanize: column_name.titleize(keep_id_suffix: true)
    end
    uri = URI('https://api.activedemand.com/v1/forms/fields.json')
    parameters = { form_id: params[:form_id], 'api-key': params[:key]}
    uri.query = URI.encode_www_form(parameters )
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      render json: { body: res.body, webhook_columns: @webhook_columns, ad_webhook: @ad_webhook.fields }
    else
      render json: { errors: res.body }, status: 409
    end
  end

  def get_fields_abandoned_cart
    @webhook = AbandonedCart.find(params[:abandoned_cart_id])
    @webhook_columns = []
    @webhook.fields.each do |column_name|
      @webhook_columns.push key: column_name, humanize: column_name.titleize(keep_id_suffix: true)
    end
    uri = URI('https://api.activedemand.com/v1/forms/fields.json')
    parameters = { form_id: params[:form_id], 'api-key': params[:key]}
    uri.query = URI.encode_www_form(parameters )
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      render json: { body: res.body, webhook_columns: @webhook_columns, ad_webhook: @webhook.ad_fields}
    else
      render json: { errors: res.body }, status: 409
    end
  end

  def save_adfields_abandoned_cart
    activedemand_array = params[:activedemand_array]
    shopify_array = params[:shopify_array]
    @abc_params = []

    shopify_array.each_with_index do |webhook, index|
      if !webhook.blank?
        @abc_params.push ad: activedemand_array[index], webhook: webhook
      end
    end

    if @abandoned_cart
      @abandoned_cart.update(ad_fields: @abc_params, form_id: params[:form_id])
    end
    render json: { body: @abc_params }
  end

  def get_script_url
    shop = Shop.find_by(shopify_domain: params[:shopify_domain])
    render json: { script_url: shop.adkey.script_url }
  end

  def create_new_account
    shop = Shop.find(params[:shop_id])
    shop.with_shopify_session do
      @shopify_shop = ShopifyAPI::Shop.current
      uri = URI("https://www2.activedemand.com/submit/form/36029")
      form_params = {}
      form_params[:"form[151_0]"] = @shopify_shop.name
      form_params[:"form[51_1]"] = @shopify_shop.myshopify_domain
      form_params[:"form[1_2]"] = @shopify_shop.shop_owner
      form_params[:"form[21_4]"] = @shopify_shop.email
      # Email address for testing
      #form_params[:"form[21_4]"] = 'testing@activedemand.com'
      form_params[:"form[227_5]"] = 'SBM'
      form_params[:"form[227_6]"] = 'Trial'
      res = Net::HTTP.post_form(uri, form_params)
      if res.is_a?(Net::HTTPSuccess)
        key = res.body[/APIKEY\[(.*?)\]APIKEY/m, 1]
        render json: { key: key, shop_email: @shopify_shop.email }
      else
        render json: { errors: res.body }, status: 409
      end
    end
  end

  private
    def set_adkey
      @adkey = Adkey.find(params[:id])
    end

    def set_abandoned_cart
      @abandoned_cart = AbandonedCart.find(params[:id])
    end

    def adkey_params
      params.require(:adkey).permit(:key, :shop_id)
    end
end
