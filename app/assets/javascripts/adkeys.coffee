# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@update_forms_and_blocks = (data) ->
  forms = JSON.parse(data.data_forms)
  blocks = JSON.parse(data.data_blocks)
  vue_forms.forms = forms
  vue_blocks.blocks = blocks

@vue_init_function = (data) ->
  $('#vue_forms').append("
    <table>
      <tr>
        <th>Form Name</th>
        <th>Code</th>
        <th>Copy</th>
      </tr>
      <tr class='form-list-item' v-bind:id='form.id' v-for='form in forms'>
        <td>{{ form.name }}</td>
        <td>{{ form.id }}</td>
        <td>Insert copy here!</td>
      </tr>
    </table>
    <span id='api-key' data-api-key='#{data.key}'></span>
  ")
  $('#vue_blocks').append("
    <table>
      <tr>
        <th>Block Name</th>
        <th>Code</th>
        <th>Copy</th>
      </tr>
      <tr v-for='block in blocks'>
        <td>{{ block.name }}</td>
        <td>{{ block.id }}</td>
        <td>Insert copy here!</td>
      </tr>
    </table>
  ")
  $('#abandoned-cart').append("
    <div>
      <label class='Polaris-Choice' for='abandoned-cart-enable'>
        <span class='Polaris-Choice__Control'>
          <span class='Polaris-Checkbox'>
            <input id='abandoned-cart-enable' type='checkbox' class='Polaris-Checkbox__Input' aria-invalid='false' role='checkbox' aria-checked='false' value='' v-if='abandoned_cart.enable' checked>
            <input id='abandoned-cart-enable' type='checkbox' class='Polaris-Checkbox__Input' aria-invalid='false' role='checkbox' aria-checked='false' value='' v-else>
            <span class='Polaris-Checkbox__Backdrop'></span>
            <span class='Polaris-Checkbox__Icon'>
              <span class='Polaris-Icon'>
                <svg class='Polaris-Icon__Svg' viewBox='0 0 20 20' focusable='false' aria-hidden='true'>
                  <path d='M8.315 13.859l-3.182-3.417a.506.506 0 0 1 0-.684l.643-.683a.437.437 0 0 1 .642 0l2.22 2.393 4.942-5.327a.437.437 0 0 1 .643 0l.643.684a.504.504 0 0 1 0 .683l-5.91 6.35a.437.437 0 0 1-.642 0'></path>
                </svg>
              </span>
            </span>
          </span>
        </span>
        <span class='Polaris-Choice__Label'>Enable abandoned cart?</span>
      </label>
    </div>
    <div id='abandoned-cart-body' v-if='abandoned_cart.enable' style='display: block;'>
      <table>
        <tr>
          <th></th>
          <th></th>
          <th>Field mapping:</th>
        </tr>
        <tr>
          <td>On adandoned cart, post to:</td>
          <td>
            <select class='form-select'>
              <option disabled selected>Choose a form</option>
              <option v-for='form in forms' v-if='form.id == abandoned_cart.form_id' selected v-bind:data-form-id='form.id'>{{form.name}}</option>
              <option v-else v-bind:data-form-id='form.id'>{{form.name}}</option>
            </select>
          </td>
          <td>
            <span class='field-mapping' v-bind:data-abandoned-cart-id='abandoned_cart.id'></span>
          </td>
        </tr>
        <tr>
          <td>Consider a cart stale if it sits for:</td>
          <td>
            <input type='number' min='1' id='abandoned-cart-time' v-bind:value='abandoned_cart.time'>
          </td>
          <td>
            <select class='time-select'>
              <option v-for='time_parser in time_parsers' v-if='abandoned_cart.time_parser == time_parser' selected >{{ time_parser }}</option>
              <option v-else>{{ time_parser }}</option>
            </select>
          </td>
        </tr>
      </table>
    </div>
    <div class='actions'>
      <button id='save-abandoned-cart' v-bind:data-abandoned-cart-id='abandoned_cart.id' class='custom-button'>Save Abandoned Cart settings
      </button>
    </div>
  ")
  abandoned_cart = data.data_abandoned_cart
  forms = JSON.parse(data.data_forms)
  blocks = JSON.parse(data.data_blocks)

  window.vue_forms = new Vue({
    el:'#vue_forms',
    data:{
      forms: forms
    }
  })
  window.vue_blocks = new Vue({
    el:'#vue_blocks',
    data:{
      blocks: blocks
    }
  })
  window.abandoned_cart = new Vue({
    el:'#abandoned-cart',
    data:{
      forms: forms,
      abandoned_cart: abandoned_cart,
      time_parsers: ['Hours', 'Days']
    }
  })
  $('#abandoned-cart').on 'click', '#abandoned-cart-enable', ->
    $('#abandoned-cart-body').toggle()
  $('#abandoned-cart').on 'click', '#save-abandoned-cart', ->
    id = $(this).data('abandoned-cart-id')
    form_id = $('#abandoned-cart .form-select option:selected').data('form-id')
    time = $('#abandoned-cart-time').val()
    time_parser = $('.time-select').val()
    enable = $('#abandoned-cart-enable').prop('checked')
    $.ajax
      type: 'PATCH'
      url:  "/update_abandoned_cart/#{id}"
      data: { form_id: form_id, time: time, enable: enable, time_parser: time_parser }
      dataType: "json"
      success: (data) ->
        ShopifyApp.flashNotice('Abandoned cart saved successfully.')
      error: (data) ->
        ShopifyApp.flashError('Something wrong with your abandoned cart. Please try again later.')
  $('#abandoned-cart').on "click", ".field-mapping", ->
    form_id = $('#abandoned-cart').find('.form-select option:selected').data('form-id')
    if form_id
      key = $('#api-key').data('api-key')
      abandoned_cart_id = $(this).data('abandoned-cart-id')
    else
      alert('Please, choose Form')
      return false
    $.ajax
      type: 'POST'
      url: '/get_fields_abandoned_cart'
      data: { form_id: form_id, key: key, abandoned_cart_id: abandoned_cart_id }
      dataType: "json"
      success: (data) ->
        field_list = JSON.parse(data.body)
        webhook_list = data.webhook_columns
        ad_webhook = data.ad_webhook
        $('#field-mapping-modal').html('').append("
          <span class='close-modal'></span>
          <table id='vue_fields_#{form_id}'>
            <tr>
              <th>ActiveDEMAND Form Field</th>
              <th>Shopify Field</th>
            </tr>
            <tr v-for='field in fields'>
              <td>{{ field.label }}</td>
              <td>
                <select class='webhook-selector-for-abandoned-cart' v-bind:data-select-for='field.key'>
                  <option selected disabled >Choose webhook field</option>
                  <option v-for='webhook in webhooks' v-bind:data-webhook-field='webhook.key' v-bind:value='webhook.key'>{{ webhook.humanize }}</option>
                </select>
              </td>
            </tr>
          </table>
          <button type='button' class='custom-button save-map-for-ab-cart' data-webhook-id='#{abandoned_cart_id}' data-form-id='#{form_id}'>Save
          </button>
        ")
        $('.app-fill').fadeIn()
        vue_fields = new Vue({
            el: "#vue_fields_#{form_id}",
            data:{
              fields: field_list
              webhooks: webhook_list
            },
            mounted: ->
              this.$nextTick ->
                if ad_webhook != []
                  $.each ad_webhook, ->
                    ad = this.ad
                    webhook = this.webhook
                    $(".webhook-selector-for-abandoned-cart[data-select-for='#{ad}']").val(webhook)
        })
        $('#field-mapping-modal').on "click", ".save-map-for-ab-cart", ->
          activedemand_array = []
          shopify_array = []
          id = $(this).data('webhook-id')
          form_id = $(this).data('form-id')
          $('.webhook-selector-for-abandoned-cart').each ->
            shopify_value = $(this).val()
            activedemand_value = $(this).data('select-for')
            activedemand_array.push(activedemand_value)
            shopify_array.push(shopify_value)
          $.ajax
            type: 'PATCH'
            url:  "/save_adfields_abandoned_cart/#{id}"
            data: { form_id: form_id, activedemand_array: activedemand_array, shopify_array: shopify_array }
            dataType: "json"
            success: (data) ->
              ShopifyApp.flashNotice('Map successfully saved')
              $('.app-fill').fadeOut()
            error: (data) ->
              ShopifyApp.flashError('Something went wrong. Please, try again later')

@vue_test_function = (key, shop_id) ->
  vue_adkey = new Vue({
    el: '#vue_adkey',
    data:{
      key: key,
      shop_id: shop_id
    },
    methods:{
      verify_key: ->
        key = this.key
        shop_id = this.shop_id
        $.ajax
          type: 'POST'
          url: '/active_demand_api_key_verification'
          data: { key: key, shop_id: shop_id }
          dataType: "json"
          success: (data) ->
            ShopifyApp.flashNotice('API key verified')
            $('#api_key_save').removeClass('Polaris-Button--disabled')
            update_forms_and_blocks(data)
          error: (data) ->
            ShopifyApp.flashError('Wrong API key')
            $('#api_key_save').addClass('Polaris-Button--disabled')
            vue_forms.forms = []
            vue_blocks.blocks = []
    }
  })
  if key != ''
    $.ajax
      type: 'POST'
      url: '/active_demand_api_key_verification'
      data: { key: key, shop_id: shop_id }
      dataType: "json"
      success: (data) ->
        vue_init_function(data)
        $('.tablinks').first().click()
      error: (data) ->
        ShopifyApp.flashError('Wrong API key')
  else
    $('#api-key-container').fadeIn()
