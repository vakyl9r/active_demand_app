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
        ShopifyApp.flashNotice('Saving your API key. Please wait.')
        button.closest('form').submit()
      error: (data) ->
        switch data.status
          when 401
            ShopifyApp.Modal.alert({
              title: "Warning!",
              message: "You have entered an invalid key. Please try again or contact support@activedemand.com",
              okButton: "I understand"
            })
          when 403
            ShopifyApp.Modal.alert({
              title: "Warning!",
              message: 'You do not have sufficient permissions to access this ActiveDEMAND account.  Please contact support@activedemand.com',
              okButton: "I understand"
            })
          else
            console.log(data)
            ShopifyApp.flashError('Something went wrong. Please, try again later.')
        vue_forms.forms = []
        vue_blocks.blocks = []
