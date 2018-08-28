class AddFieldsToWebhookNames < ActiveRecord::Migration[5.2]
  def change
    add_column :webhook_names, :fields, :text, array: true, default: []
  end
end
