class CreateUserShishas < ActiveRecord::Migration[5.1]
  def change
    create_table :user_shishas, id: false do |t|
      t.numeric :user_id, null: false
      t.numeric :shisha_id, null: false

      t.timestamps
    end
  end
end
