class ChangeDefaultFieldsInAbandonedCarts < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:abandoned_carts, :fields, ['email', 'id', 'total_price', 'subtotal_price', 'line_items',
      'abandoned_checkout_url',
      'first_name', 'last_name', 'name', 'phone', 'country',
      'province', 'city', 'address1', 'address2', 'zip', 'company',
      'latitude', 'longitude', 'country_code', 'province_code',
      'customer_id', 'customer_email','customer_accepts_marketing',
      'customer_created_at','customer_updated_at','customer_first_name',
      'customer_last_name','customer_orders_count','customer_state',
      'customer_total_spent','customer_last_order_id','customer_note','customer_verified_email',
      'customer_multipass_identifier','customer_tax_exempt','customer_phone',
      'customer_tags','customer_last_order_name'
    ])
  end
end
