class AddSuperAdminFlagToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :super_admin, :boolean, null: false, default: false
  end
end
