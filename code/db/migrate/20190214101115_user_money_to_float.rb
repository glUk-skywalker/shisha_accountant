class UserMoneyToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :money, :float
  end
end
