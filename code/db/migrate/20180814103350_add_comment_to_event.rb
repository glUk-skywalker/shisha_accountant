class AddCommentToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :comment, :text
  end
end
