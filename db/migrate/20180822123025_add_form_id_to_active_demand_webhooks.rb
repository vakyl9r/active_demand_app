class AddFormIdToActiveDemandWebhooks < ActiveRecord::Migration[5.2]
  def change
    add_column :active_demand_webhooks, :form_id, :string
  end
end
