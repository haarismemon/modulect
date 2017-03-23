class CreateSavedModules < ActiveRecord::Migration[5.0]
  def change
    create_table :saved_modules do |t|

      t.timestamps
    end
  end
end
