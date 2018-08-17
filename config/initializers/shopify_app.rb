ShopifyApp.configure do |config|
  config.application_name = "ActiveDEMAND Marketing Automation"
  config.api_key = "bec64c5d695efd0eb354cb08f6cf3e4c"
  config.secret = "62f32b04a0566b2be71671953075a1a0"
  config.scope = "read_content, write_content, read_orders, read_customers, read_script_tags, write_script_tags"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
  config.webhooks = [
    {topic: 'carts/update', address: "#{ENV['SITE_LINK']}/webhooks/carts_update", format: 'json'},
    {topic: 'orders/create', address: "#{ENV['SITE_LINK']}/webhooks/orders_create", format: 'json'},
    {topic: 'customers/create', address: "#{ENV['SITE_LINK']}/webhooks/customers_create", format: 'json'},
    {topic: 'orders/paid', address: "#{ENV['SITE_LINK']}/webhooks/orders_paid", format: 'json'},
  ]
end
