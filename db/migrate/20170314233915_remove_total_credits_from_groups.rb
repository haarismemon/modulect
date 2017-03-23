class RemoveTotalCreditsFromGroups < ActiveRecord::Migration[5.0]
  def change
  	remove_column :groups, :total_credits
  end
end
