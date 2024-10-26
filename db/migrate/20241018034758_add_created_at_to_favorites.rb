class AddCreatedAtToFavorites < ActiveRecord::Migration[6.1]
  def change
    add_column :favorites, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
