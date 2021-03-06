class AppSetting < ActiveRecord::Base
  
  # ensure only copy of the active record
  validates_inclusion_of :singleton_guard, :in => [0]

  # if the object is not found, it is returned else it is created
  def self.instance
  	
    begin
      find(1)
    rescue ActiveRecord::RecordNotFound
      row = AppSetting.new
      row.singleton_guard = 0
      allow_new_registration = true
      row.save!
      row
    end
  end


end