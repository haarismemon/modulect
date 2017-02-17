class CreateYearStructures < ActiveRecord::Migration[5.0]
  def change
    create_table :year_structures do |t|
      t.integer :year_of_study
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
