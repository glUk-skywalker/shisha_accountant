class RemoveFreeColumnFromShisha < ActiveRecord::Migration[5.1]
  def change
    remove_column :shishas, :free
  end
end
