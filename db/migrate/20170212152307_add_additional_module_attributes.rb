class AddAdditionalModuleAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :uni_modules, :pass_rate, :string
    add_column :uni_modules, :assessment_methods, :string
    add_column :uni_modules, :semester, :integer
    add_column :uni_modules, :credits, :integer
    add_column :uni_modules, :exam_percentage, :integer
    add_column :uni_modules, :coursework_percentage, :integer
    add_column :uni_modules, :requirements_id, :integer
  end
end
