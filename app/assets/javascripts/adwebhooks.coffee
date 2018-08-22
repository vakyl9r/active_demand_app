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
      $('#triggers tbody').append("<tr v-for='ad_webhook in ad_webhooks' v-bind:data-webhook='ad_webhook.id'>
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
        <td><button>Field mapping, not ready</button></td>
        <td><button class='delete-webhook' v-bind:data-webhook-id='ad_webhook.id'>DELETE</button></td>
      </tr>")
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
            alert('Not cool :(')
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
        <td><button>Field mapping, not ready</button></td>
        <td><button class='delete-webhook' data-webhook-id='#{ad_webhook.id}'>DELETE</button></td>
        </tr>")
        vue_mapping = new Vue({
          el: "[data-webhook='#{ad_webhook.id}']",
          data:{
            forms: forms,
            webhooks: webhooks
          }
        })
        alert('Cool!')
      error: (data) ->
        alert('Not cool :(')
