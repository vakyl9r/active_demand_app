if !location.href.includes('/orders/')
  $ ->
    domain = Shopify.shop
    $.ajax
      type: 'GET'
      url: "https://fa6e5fa6.ngrok.io/get_script_url"
      data: { shopify_domain: domain }
      dataType: "json"
      success: (data) ->
        script_url = data.script_url
        if script_url.length
          $.ajax
            url: script_url,
            dataType: "script",
            cache: true
            success: ->
              console.log('loaded ActiveDEMAND script')
            error: ->
              console.log('something went wrong with loading ActiveDEMAND script')
      error: ->
        console.log('server error')
