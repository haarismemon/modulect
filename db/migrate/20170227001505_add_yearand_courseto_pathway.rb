class AddYearandCoursetoPathway < ActiveRecord::Migration[5.0]
  def change
  	add_column :pathways, :year, :integer
  	add_column :pathways, :course_id, :integer
  end
end
