class AddNotifyToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :notify, :boolean, null: false, default: false
  end
end
