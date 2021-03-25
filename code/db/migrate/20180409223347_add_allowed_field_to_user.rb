class AddAllowedFieldToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :allowed, :boolean, null: false, default: false
  end
end
