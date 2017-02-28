class RemoveTutorLinkFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :tutor_link, :string
  end
end
