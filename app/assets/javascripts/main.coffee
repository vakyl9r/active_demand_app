$ ->
  $('.tablinks').on 'click', ->
    tab = $(this).data('tab')
    $('.tablinks').removeClass('active')
    $(this).addClass('active')
    $('.tabcontent').css('display', 'none')
    $('#' + tab).css('display', 'block')

  $('#api-key-container').on 'click', '.close-modal', ->
    $('#api-key-container').fadeOut()

  $('#api_key_save').on 'click', (e) ->
    e.preventDefault()
    key = $('#adkey_key').val()
    shop_id = $('#shop-id').data('shop-id')
    button = $(this)
    $.ajax
      type: 'POST'
      url: '/active_demand_api_key_verification'
      data: { key: key, shop_id: shop_id }
      dataType: "json"
      success: (data) ->
        ShopifyApp.flashNotice('API key successfully saved')
        button.closest('form').submit()
      error: (data) ->
        ShopifyApp.flashError('Wrong or Empty API key')
        vue_forms.forms = []
        vue_blocks.blocks = []
