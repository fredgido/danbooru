class AddLegacyPasswordToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :legacy_password_hash, :text
  end
end
