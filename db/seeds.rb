# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
WebhookName.delete_all

WebhookName.create([
  {
    name: 'Create Order',
    topic: 'orders/create',
    fields: ['email', 'id','order_number','total_price','subtotal_price',
      'order_status_url', 'line_items',
      'first_name', 'last_name', 'name', 'phone', 'country',
      'province', 'city', 'address1', 'address2', 'zip', 'company','latitude',
      'longitude','country_code','province_code',
      'customer_id', 'customer_email','customer_accepts_marketing',
      'customer_created_at','customer_updated_at','customer_first_name',
      'customer_last_name','customer_orders_count','customer_state',
      'customer_total_spent','customer_last_order_id','customer_note','customer_verified_email',
      'customer_multipass_identifier','customer_tax_exempt','customer_phone',
      'customer_tags','customer_last_order_name'
    ]
  },
  {
    name: 'Paid Order',
    topic: 'orders/paid',
    fields: ['email', 'id','order_number','total_price','subtotal_price',
      'order_status_url', 'line_items',
      'first_name', 'last_name', 'name', 'phone', 'country',
      'province', 'city', 'address1', 'address2', 'zip', 'company','latitude',
      'longitude','country_code','province_code',
      'customer_id', 'customer_email','customer_accepts_marketing',
      'customer_created_at','customer_updated_at','customer_first_name',
      'customer_last_name','customer_orders_count','customer_state',
      'customer_total_spent','customer_last_order_id','customer_note','customer_verified_email',
      'customer_multipass_identifier','customer_tax_exempt','customer_phone',
      'customer_tags','customer_last_order_name'
    ]
  },
  {
    name: 'Cancelled Order',
    topic: 'orders/cancelled',
    fields: ['email', 'id','order_number','total_price','subtotal_price',
      'order_status_url', 'line_items',
      'first_name', 'last_name', 'name', 'phone', 'country',
      'province', 'city', 'address1', 'address2', 'zip', 'company','latitude',
      'longitude','country_code','province_code',
      'customer_id', 'customer_email','customer_accepts_marketing',
      'customer_created_at','customer_updated_at','customer_first_name',
      'customer_last_name','customer_orders_count','customer_state',
      'customer_total_spent','customer_last_order_id','customer_note','customer_verified_email',
      'customer_multipass_identifier','customer_tax_exempt','customer_phone',
      'customer_tags','customer_last_order_name'
    ]
  },
  {
    name: 'Updated Order',
    topic: 'orders/updated',
    fields: ['email', 'id','order_number','total_price','subtotal_price',
      'order_status_url', 'line_items',
      'first_name', 'last_name', 'name', 'phone', 'country',
      'province', 'city', 'address1', 'address2', 'zip', 'company','latitude',
      'longitude','country_code','province_code',
      'customer_id', 'customer_email','customer_accepts_marketing',
      'customer_created_at','customer_updated_at','customer_first_name',
      'customer_last_name','customer_orders_count','customer_state',
      'customer_total_spent','customer_last_order_id','customer_note','customer_verified_email',
      'customer_multipass_identifier','customer_tax_exempt','customer_phone',
      'customer_tags','customer_last_order_name'
    ]
  },
  {
    name: 'Create Checkout',
    topic: 'checkouts/create',
    fields: ['email', 'id', 'total_price', 'subtotal_price', 'line_items',
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
    ]
  },
  {
    name: 'Update Checkout',
    topic: 'checkouts/update',
    fields: ['email', 'id', 'total_price', 'subtotal_price', 'line_items',
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
    ]
  },
  {
    name: 'Delete Checkout',
    topic: 'checkouts/delete',
    fields: ['email', 'id', 'total_price', 'subtotal_price', 'line_items',
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
    ]
  },
  {
    name: 'Create Customer',
    topic: 'customers/create',
    fields: ['id', 'email', 'accepts_marketing', 'created_at', 'updated_at',
      'first_name', 'last_name', 'orders_count', 'state', 'total_spent',
      'last_order_id','verified_email','multipass_identifier','tax_exempt',
      'last_order_name', 'name', 'phone', 'country', 'province', 'city',
      'address1', 'address2', 'zip', 'company', 'note', 'tags']
  },
  {
    name: 'Update Customer',
    topic: 'customers/update',
    fields: ['id', 'email', 'accepts_marketing', 'created_at', 'updated_at',
      'first_name', 'last_name', 'orders_count', 'state', 'total_spent',
      'last_order_id', 'verified_email', 'multipass_identifier', 'tax_exempt',
      'last_order_name', 'name', 'phone', 'country', 'province', 'city',
      'address1', 'address2', 'zip', 'company', 'note', 'tags']
  }
])
