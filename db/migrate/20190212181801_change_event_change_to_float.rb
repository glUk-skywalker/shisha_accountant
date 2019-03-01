class ChangeEventChangeToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :events, :change, :float
  end
end
