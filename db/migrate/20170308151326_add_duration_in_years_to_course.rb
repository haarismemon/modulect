class AddDurationInYearsToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :duration_in_years, :integer, default: 3
  end
end
