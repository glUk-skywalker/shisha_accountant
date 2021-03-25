class EventCurrentToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :events, :current, :float
  end
end
