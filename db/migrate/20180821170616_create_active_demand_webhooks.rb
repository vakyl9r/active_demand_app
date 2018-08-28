class CreateActiveDemandWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :active_demand_webhooks do |t|
      t.references :shop, foreign_key: true
      t.string :topic
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :full_name
      t.string :phone
      t.string :country
      t.string :province
      t.string :city
      t.string :address_1
      t.string :address_2
      t.string :zip
      t.string :company

      t.timestamps
    end
  end
end
