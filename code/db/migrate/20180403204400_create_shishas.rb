class CreateShishas < ActiveRecord::Migration[5.1]
  def change
    create_table :shishas do |t|
      t.numeric :price, null: false
      t.boolean :current, default: true

      t.timestamps
    end
  end
end
