class AddFreeToShisha < ActiveRecord::Migration[5.1]
  def change
    add_column :shishas, :free, :boolean
  end
end
