class AddAssessmentDatesToUniModules < ActiveRecord::Migration[5.0]
  def change
  	add_column :uni_modules, :assessment_dates, :string
  end
end
