# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@update_forms_and_blocks = (data) ->
  $('#vue_forms').html('').append("<ul><li class='form-list-item' v-bind:id='form.id' v-for='form in forms'>{{ form }}</li></ul>")
  $('#vue_blocks').html('').append("<ul><li v-for='block in blocks'>{{ block }}</li></ul>")
  forms = JSON.parse(data.data_forms)
  blocks = JSON.parse(data.data_blocks)
  vue_forms = new Vue({
    el:'#vue_forms',
    data:{
      forms: forms
    }
  })
  $('.form-list-item').each ->
    form_list_item = $(this)
    id = form_list_item[0].id
    $.ajax
      type: 'POST'
      url: '/get_fields'
      data: { key: data.key, form_id: id }
      dataType: "json"
      success: (data) ->
        field_list = JSON.parse(data.body)
        form_list_item.append("<ul id='vue_fields_#{id}'><li v-for='field in fields'>{{ field }}</li></ul>")
        vue_fields = new Vue({
            el: "#vue_fields_#{id}",
            data:{
              fields: field_list
            }
        })
      error: (data) ->
        ShopifyApp.flashError('Bad fields!')
  vue_blocks = new Vue({
    el:'#vue_blocks',
    data:{
      blocks: blocks
    }
  })
@vue_test_function = (key) ->
  vue_adkey = new Vue({
    el: '#vue_adkey',
    data:{
      key: key
    },
    methods:{
      verify_key: ->
        key = this.key
        $.ajax
          type: 'POST'
          url: '/active_demand_api_key_verification'
          data: { key: key }
          dataType: "json"
          success: (data) ->
            ShopifyApp.flashNotice('API key verified')
            update_forms_and_blocks(data)
          error: (data) ->
            ShopifyApp.flashError('Wrong API key')
            $('#vue_forms').html('')
            $('#vue_blocks').html('')
    }
  })
  $.ajax
    type: 'POST'
    url: '/active_demand_api_key_verification'
    data: { key: key }
    dataType: "json"
    success: (data) ->
      update_forms_and_blocks(data)
    error: (data) ->
      ShopifyApp.flashError('Wrong API key')
