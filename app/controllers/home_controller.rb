class HomeController < ShopifyApp::AuthenticatedController
  def index
    @webhooks = ShopifyAPI::Webhook.find(:all)
    @shop = Shop.find_by(shopify_domain: ShopifyAPI::Shop.current.domain)
    @adkey = Adkey.find_or_create_by(shop_id: @shop.id)
  end
end
