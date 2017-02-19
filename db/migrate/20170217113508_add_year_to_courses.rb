class AddYearToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :year, :integer
  end
end
