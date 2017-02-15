class AddFacultyIdToDepartments < ActiveRecord::Migration[5.0]
  def change
    add_column :departments, :faculty_id, :integer
    add_index  :departments, :faculty_id
  end
end
