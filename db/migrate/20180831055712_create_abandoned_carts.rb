class CreateAbandonedCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :abandoned_carts do |t|
      t.references :shop, foreign_key: true
      t.boolean :enable, default: false
      t.text :fields, array: true, default: ['email', 'first_name', 'last_name', 'name', 'phone', 'country', 'province', 'city', 'address1', 'address2', 'zip', 'company']
      t.jsonb :ad_fields, array: true, default: []
      t.string :form_id
      t.integer :time

      t.timestamps
    end
  end
end
