class AddTutolinkToUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :tutor_link, :string
  end
end
