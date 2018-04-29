class CreateLoginTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :login_tokens, id: false do |t|
      t.numeric :user_id, null: false
      t.string :token, null: false

      t.timestamps
    end
  end
end
