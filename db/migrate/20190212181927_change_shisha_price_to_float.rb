class ChangeShishaPriceToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :shishas, :price, :float
  end
end
