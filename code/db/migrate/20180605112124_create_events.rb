class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.numeric :change
      t.numeric :current
      t.integer :user_id
      t.integer :shisha_id

      t.timestamps
    end
  end
end
