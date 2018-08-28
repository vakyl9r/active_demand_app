class RemoveColumnsFromActiveDemandWebhook < ActiveRecord::Migration[5.2]
  def change
    add_column :active_demand_webhooks, :fields, :text, array: true, default: []
    remove_column :active_demand_webhooks, :email
    remove_column :active_demand_webhooks, :first_name
    remove_column :active_demand_webhooks, :last_name
    remove_column :active_demand_webhooks, :full_name
    remove_column :active_demand_webhooks, :phone
    remove_column :active_demand_webhooks, :country
    remove_column :active_demand_webhooks, :province
    remove_column :active_demand_webhooks, :city
    remove_column :active_demand_webhooks, :address_1
    remove_column :active_demand_webhooks, :address_2
    remove_column :active_demand_webhooks, :zip
    remove_column :active_demand_webhooks, :company
  end
end
