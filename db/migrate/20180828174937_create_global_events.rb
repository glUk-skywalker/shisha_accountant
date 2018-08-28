class CreateGlobalEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :global_events do |t|
      t.numeric :change, null: false
      t.string :comment

      t.timestamps
    end
  end
end
