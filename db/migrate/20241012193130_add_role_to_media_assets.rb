class AddRoleToMediaAssets < ActiveRecord::Migration[7.1]
  def change
    add_column :media_assets, :role, :string, null: false, default: "image"
  end
end
