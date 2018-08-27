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
    fields: ['email', 'first_name', 'last_name', 'name', 'phone', 'country', 'province', 'city', 'address1', 'address2', 'zip', 'company']
  },
  {
    name: 'Paid Order',
    topic: 'orders/paid',
    fields: ['email', 'first_name', 'last_name', 'name', 'phone', 'country', 'province', 'city', 'address1', 'address2', 'zip', 'company']
  },
  {
    name: 'Cancelled Order',
    topic: 'orders/cancelled',
    fields: ['email', 'first_name', 'last_name', 'name', 'phone', 'country', 'province', 'city', 'address1', 'address2', 'zip', 'company']
  },
  {
    name: 'Updated Order',
    topic: 'orders/updated',
    fields: ['email', 'first_name', 'last_name', 'name', 'phone', 'country', 'province', 'city', 'address1', 'address2', 'zip', 'company']
  },
  {
    name: 'Create Checkout',
    topic: 'checkouts/create',
    fields: ['email', 'first_name', 'last_name', 'name', 'phone', 'country', 'province', 'city', 'address1', 'address2', 'zip', 'company']
  },
  {
    name: 'Update Checkout',
    topic: 'checkouts/update',
    fields: ['email', 'first_name', 'last_name', 'name', 'phone', 'country', 'province', 'city', 'address1', 'address2', 'zip', 'company']
  },
  {
    name: 'Delete Checkout',
    topic: 'checkouts/delete',
    fields: ['email', 'first_name', 'last_name', 'name', 'phone', 'country', 'province', 'city', 'address1', 'address2', 'zip', 'company']
  }
])
