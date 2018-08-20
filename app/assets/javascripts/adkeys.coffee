# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@displayActiveDEMANDList = (key) ->
  $.ajax
    type: 'POST'
    url: '/active_demand_api_key_verification'
    data: { key: key }
    dataType: "json"
    success: (data) ->
      forms = JSON.parse(data.data_forms)
      blocks = JSON.parse(data.data_blocks)
      $('#active-demand-forms-container').append("
        <ul class='list form-list'>
        </ul>
      ")
      $.each forms, (i) ->
        $('.form-list').append("
          <li id='form-#{i}'>#{forms[i].id} - #{forms[i].name} - [activedemand_form id='#{forms[i].id}']</li>
        ")
        $.ajax
          type: 'POST'
          url: '/get_fields'
          data: { key: key, form_id: forms[i].id }
          dataType: "json"
          success: (data) ->
            response = JSON.parse(data.body)
            $("#form-#{i}").append("
              <ul id='form-fields-#{i}'>
              </ul>
            ")
            $.each response, (x) ->
              $("#form-fields-#{i}").append("
                <li>#{response[x].key} - #{response[x].label}</li>
              ")
          error: (data) ->
            ShopifyApp.flashError('Bad fields!')
      $('#active-demand-blocks-container').append("
        <ul class='list block-list'>
        </ul>
      ")
      $.each blocks, (i) ->
        $('.block-list').append("
          <li id='block-#{i}'>#{blocks[i].id} - #{blocks[i].name} - [activedemand_block id='#{blocks[i].id}']</li>
        ")
    error: (data) ->
      ShopifyApp.flashError('Something wrong with your API key')

$ ->
  $('#adkey_key').on 'change', ->
    api_key = $(this).val()
    $.ajax
      type: 'POST'
      url: '/active_demand_api_key_verification'
      data: { key: api_key}
      dataType: "json"
      success: (data) ->
        response = JSON.parse(data.data)
        alert(response[0].name)
      error: (data) ->
        ShopifyApp.flashError('Something wrong with your API key')
