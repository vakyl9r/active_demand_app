class AdkeysController < ApplicationController
  before_action :set_adkey, only: [:show, :edit, :update, :destroy]
  respond_to :js, :html, :json
  require 'net/http'

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
      if @adkey.update(adkey_params)
        format.html { redirect_to root_path, notice: 'Api Key was successfully updated.' }
        format.json { render :show, status: :ok, location: @adkey }
      else
        format.html { render :edit }
        format.json { render json: @adkey.errors, status: :unprocessable_entity }
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
    if res.is_a?(Net::HTTPSuccess)
      render json: { data_forms: res.body, data_blocks: res2.body, key: params[:key], data_webhooks: @shopify_webhooks }
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
      @webhook_columns.push key: column_name, humanize: column_name.titleize
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

  def save_adfields
    activedemand_array = params[:activedemand_array]
    shopify_array = params[:shopify_array]
    webhook_topic = params[:webhook_topic]
    id = params[:id]
    @adw_params = []
    shopify_array.each_with_index do |webhook, index|
      if !webhook.blank?
        table_column = webhook.remove(' ').tableize.singularize
        @adw_params.push "#{activedemand_array[index]}": table_column
      end
    end
    @activedemandwebhook = ActiveDemandWebhook.find_by(id: id)
    if @activedemandwebhook
      @activedemandwebhook.update(topic: webhook_topic, fields: @adw_params)
    end
    #ActiveDemandWebhook.create(shop_id: shop_id, topic: webhook_topic, fields: @adw_params)
    render json: { body: @adw_params }
  end

  private
    def set_adkey
      @adkey = Adkey.find(params[:id])
    end

    def adkey_params
      params.require(:adkey).permit(:key, :shop_id)
    end
end
