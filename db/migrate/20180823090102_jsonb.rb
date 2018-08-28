class Jsonb < ActiveRecord::Migration[5.2]
  def change
    remove_column :active_demand_webhooks, :fields
    add_column :active_demand_webhooks, :fields, :jsonb, array: true, default: []
  end
end
