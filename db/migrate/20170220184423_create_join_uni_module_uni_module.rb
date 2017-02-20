class CreateJoinUniModuleUniModule < ActiveRecord::Migration[5.0]
  def change
  	create_table "uni_module_requirements", :force => true, :id => false do |t|
		  t.integer "uni_module_id", :null => false
		  t.integer "required_uni_module_id", :null => false
		end
  end
end
