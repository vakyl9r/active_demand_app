class AddScriptUrlToAdkeys < ActiveRecord::Migration[5.2]
  def change
    add_column :adkeys, :script_url, :string
  end
end
