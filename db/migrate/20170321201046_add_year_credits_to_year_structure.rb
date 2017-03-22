class AddYearCreditsToYearStructure < ActiveRecord::Migration[5.0]
  def change
  	add_column :year_structures, :year_credits, :integer, default: 120
  end
end
