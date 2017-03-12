class AddIsLimitedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_limited, :boolean, default: false
  end
end
