class CreateUniModuleLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :uni_module_logs do |t|
      t.integer "module_id"
      t.integer "counter"

      t.timestamps
    end
  end
end
