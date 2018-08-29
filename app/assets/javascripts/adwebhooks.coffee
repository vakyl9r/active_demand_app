@all_ad_webhooks = (shop_id) ->
  $.ajax
    type: 'POST'
    url: '/all_ad_webhooks'
    data: { shop_id: shop_id }
    dataType: "json"
    success: (data) ->
      ad_webhooks = data.ad_webhooks
      forms = JSON.parse(data.forms)
      webhooks = data.webhooks
      $('#triggers tbody').append("
        <tr>
          <th>Trigger</th>
          <th>Post to form</th>
          <th>Field Mapping</th>
          <th></th>
        </tr>
        <tr v-for='ad_webhook in ad_webhooks' v-bind:data-webhook='ad_webhook.id'>
          <td>
            <select class='webhook-select'>
              <option disabled v-if='ad_webhook.topic'>Choose a webhook</option>
              <option disabled v-else selected>Choose a webhook</option>
              <option v-for='webhook in webhooks' v-if='webhook.topic == ad_webhook.topic' selected v-bind:data-webhook-topic='webhook.topic'>{{ webhook.name }}</option>
              <option v-else v-bind:data-webhook-topic='webhook.topic'>{{ webhook.name }}</option>
            </select>
          </td>
          <td>
            <select class='form-select'>
              <option disabled selected>Choose a form</option>
              <option v-for='form in forms' v-if='form.id == ad_webhook.form_id' selected v-bind:data-form-id='form.id'>{{form.name}}</option>
              <option v-else v-bind:data-form-id='form.id'>{{form.name}}</option>
            </select>
          </td>
          <td><span class='field-mapping' v-bind:data-webhook-id='ad_webhook.id'></span></td>
          <td><span class='delete-webhook' v-bind:data-webhook-id='ad_webhook.id'></span></td>
        </tr>
      ")
      vue_all_ad_webhooks = new Vue({
        el: "#triggers",
        data:{
          forms: forms,
          webhooks: webhooks,
          ad_webhooks: ad_webhooks
        }
      })
      $('#triggers').on "click", ".delete-webhook", ->
        id = $(this).data('webhook-id')
        $.ajax
          type: 'DELETE'
          url:  "/active_demand_webhooks/#{id}"
          dataType: "json"
          success: (data) ->
            $("[data-webhook='#{id}']").remove()
          error: (data) ->
            ShopifyApp.flashError('Something went wrong. Please, try again later')
      $('#triggers').on "click", ".field-mapping", ->
        webhook_topic = $(this).closest('tr').find('.webhook-select option:selected').data('webhook-topic')
        if webhook_topic != undefined
          form_id = $(this).closest('tr').find('.form-select option:selected').data('form-id')
          if form_id != undefined
            key = $('#api-key').data('api-key')
            webhook_id = $(this).data('webhook-id')
          else
            alert('Please, choose Form')
            return false
        else
          alert('Please, choose Trigger')
          return false
        $.ajax
          type: 'POST'
          url: '/get_fields'
          data: { form_id: form_id, key: key, webhook_topic: webhook_topic, webhook_id: webhook_id }
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
                    <select class='webhook-selector' v-bind:data-select-for='field.key'>
                      <option selected disabled >Choose webhook field</option>
                      <option v-for='webhook in webhooks' v-bind:data-webhook-field='webhook.key' v-bind:value='webhook.key'>{{ webhook.humanize }}</option>
                    </select>
                  </td>
                </tr>
              </table>
              <span class='save-map' data-webhook-topic='#{webhook_topic}' data-webhook-id='#{webhook_id}' data-form-id='#{form_id}'>Save</span>
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
                        $(".webhook-selector[data-select-for='#{ad}']").val(webhook)
            })
            $('#field-mapping-modal').on "click", ".save-map", ->
              activedemand_array = []
              shopify_array = []
              webhook_topic = $(this).data('webhook-topic')
              id = $(this).data('webhook-id')
              form_id = $(this).data('form-id')
              $('.webhook-selector').each ->
                shopify_value = $(this).val()
                activedemand_value = $(this).data('select-for')
                activedemand_array.push(activedemand_value)
                shopify_array.push(shopify_value)
              $.ajax
                type: 'PATCH'
                url:  "/active_demand_webhooks/#{id}"
                data: { form_id: form_id, activedemand_array: activedemand_array, shopify_array: shopify_array, webhook_topic: webhook_topic }
                dataType: "json"
                success: (data) ->
                  ShopifyApp.flashNotice('Map successfully saved')
                  $('.app-fill').fadeOut()
                error: (data) ->
                  ShopifyApp.flashError('Something went wrong. Please, try again later')
      $('#field-mapping-modal').on "click", ".close-modal", ->
        $('.app-fill').fadeOut();
      $(document).on 'click', (event) ->
        if !$(event.target).closest('#field-mapping-modal').length
          $('.app-fill').fadeOut()
    error: (data) ->
$ ->
  $('.create-new-webhook').click ->
    shop_id = $('#shop-id').data('shop-id')
    $.ajax
      type: 'POST'
      url: '/active_demand_webhooks'
      data: { shop_id: shop_id }
      dataType: "json"
      success: (data) ->
        ad_webhook = data.ad_webhook
        forms = JSON.parse(data.forms)
        webhooks = data.webhooks
        $('#triggers tbody').append("<tr data-webhook='#{ad_webhook.id}'>
        <td>
          <select class='webhook-select'>
            <option disabled selected>Choose a webhook</option>
            <option v-for='webhook in webhooks' v-bind:data-webhook-topic='webhook.topic'>{{webhook.name}}</option>
          </select>
        </td>
        <td>
          <select class='form-select'>
            <option disabled selected>Choose a form</option>
            <option v-for='form in forms' v-bind:data-form-id='form.id'>{{form.name}}</option>
          </select>
        </td>
        <td><span class='field-mapping' data-webhook-id='#{ad_webhook.id}'></span></td>
        <td><span class='delete-webhook' data-webhook-id='#{ad_webhook.id}'></span></td>
        </tr>")
        vue_mapping = new Vue({
          el: "[data-webhook='#{ad_webhook.id}']",
          data:{
            forms: forms,
            webhooks: webhooks
          }
        })
        ShopifyApp.flashNotice('New trigger created successfully')
      error: (data) ->
        ShopifyApp.flashError('Something went wrong. Please, try again later')
