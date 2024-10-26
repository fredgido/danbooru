class AddIsVisibleOnProfileToSavedSearches < ActiveRecord::Migration[6.1]
  def change
    add_column :saved_searches, :is_visible_on_profile, :boolean, default: false, null: false
  end
end
