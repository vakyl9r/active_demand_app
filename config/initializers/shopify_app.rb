ShopifyApp.configure do |config|
  config.application_name = "ActiveDEMAND Marketing Automation"
  config.api_key = "bec64c5d695efd0eb354cb08f6cf3e4c"
  config.secret = "62f32b04a0566b2be71671953075a1a0"
  config.scope = "read_orders, read_customers, read_script_tags, write_script_tags"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
  config.scripttags = [
    {event:'onload', src: "#{ENV['SITE_LINK']}/assets/clientside.js"}
  ]
  config.webhooks = [
    {topic: 'customers/create', address: "#{ENV['SITE_LINK']}/webhooks/customers_create", format: 'json'},
    {topic: 'customers/update', address: "#{ENV['SITE_LINK']}/webhooks/customers_update", format: 'json'},
    {topic: 'orders/create', address: "#{ENV['SITE_LINK']}/webhooks/orders_create", format: 'json'},
    {topic: 'orders/paid', address: "#{ENV['SITE_LINK']}/webhooks/orders_paid", format: 'json'},
    {topic: 'orders/cancelled', address: "#{ENV['SITE_LINK']}/webhooks/orders_cancelled", format: 'json'},
    {topic: 'orders/updated', address: "#{ENV['SITE_LINK']}/webhooks/orders_updated", format: 'json'},
    {topic: 'checkouts/create', address: "#{ENV['SITE_LINK']}/webhooks/checkouts_create", format: 'json'},
    {topic: 'checkouts/update', address: "#{ENV['SITE_LINK']}/abandoned_carts/checkouts_update", format: 'json'},
  ]
end
