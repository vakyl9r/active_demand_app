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
    if res.is_a?(Net::HTTPSuccess)
      render json: { data_forms: res.body, data_blocks: res2.body }
    else
      render json: { errors: res.body }, status: 409
    end
  end

  def get_fields
    uri = URI('https://api.activedemand.com/v1/forms/fields.json')
    parameters = { form_id: params[:form_id], 'api-key': params[:key]}
    uri.query = URI.encode_www_form(parameters )
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      render json: { body: res.body }
    else
      render json: { errors: res.body }, status: 409
    end
  end

  private
    def set_adkey
      @adkey = Adkey.find(params[:id])
    end

    def adkey_params
      params.require(:adkey).permit(:key, :shop_id)
    end
end
