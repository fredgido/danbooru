class CreateProfilePictures < ActiveRecord::Migration[7.1]
  def change
    create_table :profile_pictures do |t|
      t.integer :left, null: false
      t.integer :top, null: false
      t.integer :width, null: false
      t.integer :height, null: false

      t.references :user, null: false, index: true
      t.references :source_media_asset, null: false, index: true, foreign_key: { to_table: :media_assets }
      t.references :avatar_media_asset, null: false, index: true, foreign_key: { to_table: :media_assets }

      t.timestamps
    end
  end
end
