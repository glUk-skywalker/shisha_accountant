class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, id: false do |t|
      t.numeric :id, primary_key: true, null: false, auto_increment: false, unique: true
      t.boolean :is_bot, null: false
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :language_code, null: false
      t.numeric :money, null: false, unique: true, default: 0

      t.timestamps
    end
  end
end
