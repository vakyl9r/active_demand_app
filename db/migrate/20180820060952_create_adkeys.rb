class CreateAdkeys < ActiveRecord::Migration[5.2]
  def change
    create_table :adkeys do |t|
      t.string :key
      t.belongs_to :shop, foreign_key: true

      t.timestamps
    end
  end
end
