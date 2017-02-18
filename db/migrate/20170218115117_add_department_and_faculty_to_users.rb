class AddDepartmentAndFacultyToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :department_id, :integer
    add_column :users, :faculty_id, :integer
  end
end
