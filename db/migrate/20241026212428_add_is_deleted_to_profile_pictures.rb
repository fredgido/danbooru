class AddIsDeletedToProfilePictures < ActiveRecord::Migration[7.1]
  def change
    add_column :profile_pictures, :is_deleted, :boolean, null: false, default: false
  end
end
