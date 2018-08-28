class CreateWebhookNames < ActiveRecord::Migration[5.2]
  def change
    create_table :webhook_names do |t|
      t.string :name
      t.string :topic

      t.timestamps
    end
  end
end
