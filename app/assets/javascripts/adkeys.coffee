# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@update_forms_and_blocks = (data) ->
  $('#vue_forms').html('').append("
    <table>
      <tr>
        <th>Form Name</th>
        <th>Code</th>
      </tr>
      <tr class='form-list-item' v-bind:id='form.id' v-for='form in forms'>
        <td>{{ form.name }}</td>
        <td>{{ form.id }}</td>
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
