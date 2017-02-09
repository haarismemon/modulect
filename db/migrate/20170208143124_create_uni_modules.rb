class CreateUniModules < ActiveRecord::Migration[5.0]
  def change
    create_table :uni_modules do |t|
      t.string :name
      t.string :code
      t.string :description
      t.string :lecturers

      t.timestamps
    end
  end
end
