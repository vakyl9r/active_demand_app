# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@update_forms_and_blocks = (data) ->
  $('#vue_forms').html('').append("
    <table>
      <tr>
        <th>Form Name</th>
        <th>Code</th>
        <th>Webhook</th>
        <th>Field Mapping</th>
      </tr>
      <tr class='form-list-item' v-bind:id='form.id' v-for='form in forms'>
        <td>{{ form.name }}</td>
        <td>{{ form.id }}</td>
        <td>
          <select class='webhook-name-select'>
            <option selected disabled>Choose webhook</option>
            <option v-for='webhook in webhooks' v-bind:data-webhook-topic='webhook.topic'>{{ webhook.name }}</option>
          </select>
        </td>
        <td><span class='field-mapping' v-bind:data-form-id='form.id'></span></td>
      </tr>
    </table>
    <span id='api-key' data-api-key='#{data.key}'></span>
  ")
  $('#vue_blocks').html('').append("
    <table>
      <tr>
        <th>Block Name</th>
        <th>Code</th>
      </tr>
      <tr v-for='block in blocks'>
        <td>{{ block.name }}</td>
        <td>{{ block.id }}</td>
      </tr>
    </table>
  ")
  forms = JSON.parse(data.data_forms)
  blocks = JSON.parse(data.data_blocks)
  webhooks = data.data_webhooks
  vue_forms = new Vue({
    el:'#vue_forms',
    data:{
      forms: forms,
      webhooks: webhooks
    }
  })
  vue_blocks = new Vue({
    el:'#vue_blocks',
    data:{
      blocks: blocks
    }
  })
  $('#vue_forms').on "click", ".field-mapping", ->
    id = $(this).data('form-id')
    webhook_topic = $(this).closest('.form-list-item').find('.webhook-name-select option:selected').data('webhook-topic')
    key = $('#api-key').data('api-key')
    $.ajax
      type: 'POST'
      url: '/get_fields'
      data: { form_id: id, key: key, webhook_topic: webhook_topic }
      dataType: "json"
      success: (data) ->
        field_list = JSON.parse(data.body)
        webhook_list = data.webhook_columns
        $('#field-mapping-modal').html('').append("
          <span class='close-modal'></span>
          <table id='vue_fields_#{id}'>
            <tr>
              <th>ActiveDEMAND Form Field</th>
              <th>Shopify Field</th>
            </tr>
            <tr v-for='field in fields'>
              <td>{{ field.label }}</td>
              <td>
                <select class='webhook-select' v-bind:data-select-for='field.key'>
                  <option selected disabled>Choose webhook field</option>
                  <option v-for='webhook in webhooks'>{{ webhook }}</option>
                </select>
              </td>
            </tr>
          </table>
          <span class='save-map' data-webhook-topic='#{webhook_topic}'>Save</span>
        ")
        $('.app-fill').fadeIn()
        vue_fields = new Vue({
            el: "#vue_fields_#{id}",
            data:{
              fields: field_list
              webhooks: webhook_list
            }
        })
        $('#field-mapping-modal').on "click", ".save-map", ->
          activedemand_array = []
          shopify_array = []
          webhook_topic = $(this).data('webhook-topic')
          id = 2
          $('.webhook-select').each ->
            shopify_value = $(this).val()
            activedemand_value = $(this).data('select-for')
            activedemand_array.push(activedemand_value)
            shopify_array.push(shopify_value)
          $.ajax
            type: 'POST'
            url: '/save_adfields'
            data: { activedemand_array: activedemand_array, shopify_array: shopify_array, id: id, webhook_topic: webhook_topic }
            dataType: "json"
            success: (data) ->
              debugger
              alert('Cool!')
            error: (data) ->
              alert('Not cool :(')
      error: (data) ->
        ShopifyApp.flashError('Bad fields!')
  $('#field-mapping-modal').on "click", ".close-modal", ->
    $('.app-fill').fadeOut();
  $(document).on 'click', (event) ->
    if !$(event.target).closest('#field-mapping-modal').length
      $('.app-fill').fadeOut()
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
