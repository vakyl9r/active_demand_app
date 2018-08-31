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
    <p>
      Enable abandoned cart?
      <input type='checkbox' v-bind:value='abandoned_cart.enable' id='abandoned-cart-enable'>
    </p
    <p>On adandoned cart, post to:
      <select class='form-select'>
        <option disabled selected>Choose a form</option>
        <option v-for='form in forms' v-if='form.id == abandoned_cart.form_id' selected v-bind:data-form-id='form.id'>{{form.name}}</option>
        <option v-else v-bind:data-form-id='form.id'>{{form.name}}</option>
      </select>
      <span class='field-mapping'></span>
    </p>
    <p>
      Consider a cart stale if it sits for:
      <input type='number' min='1' id='abandoned-cart-time'>
      <select class='time-select'>
        <option>Minute</option>
        <option>Hours</option>
        <option>Weeks</option>
      </select>
    </p>
    <button id='save-abandoned-cart' v-bind:data-abandoned-cart-id='abandoned_cart.id' >Save cart settings</button>
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
      abandoned_cart: abandoned_cart
    }
  })
  $('#abandoned-cart').on 'click', '#save-abandoned-cart', ->
    id = $(this).data('abandoned-cart-id')
    form_id = $('#abandoned-cart .form-select option:selected').data('form-id')
    time = $('#abandoned-cart-time').val()
    time_parser = $('.time-select').val()
    enable = $('#abandoned-cart-enable').val()
    $.ajax
      type: 'PATCH'
      url:  "/abandoned_carts/#{id}"
      data: { form_id: form_id, time: time, enable: enable }
      dataType: "json"
      success: (data) ->
        alert('AbandonedCart saved')
      error: (data) ->
        alert('AbandonedCart save error!')

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
            update_forms_and_blocks(data)
          error: (data) ->
            ShopifyApp.flashError('Wrong API key')
            vue_forms.forms = []
            vue_blocks.blocks = []
    }
  })
  $.ajax
    type: 'POST'
    url: '/active_demand_api_key_verification'
    data: { key: key, shop_id: shop_id }
    dataType: "json"
    success: (data) ->
      vue_init_function(data)
    error: (data) ->
      ShopifyApp.flashError('Wrong API key')
