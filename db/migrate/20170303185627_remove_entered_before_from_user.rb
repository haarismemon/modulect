class RemoveEnteredBeforeFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :entered_before, :boolean
  end
end
