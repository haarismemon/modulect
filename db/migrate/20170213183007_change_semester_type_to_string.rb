class ChangeSemesterTypeToString < ActiveRecord::Migration[5.0]
  def change
    change_column :uni_modules, :semester, :string
  end
end
