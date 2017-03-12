class ChangeCommenterNameToUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :commenter
    add_column :comments, :user_id, :integer
    add_index  :comments, :user_id
  end
end
