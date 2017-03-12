class AppSetting < ActiveRecord::Base
  # The "singleton_guard" column is a unique column which must always be set to '0'
  # This ensures that only one AppSettings row is created
  validates_inclusion_of :singleton_guard, :in => [0]

  def self.instance
    # there will be only one row, and its ID must be '1'
    begin
      find(1)
    rescue ActiveRecord::RecordNotFound
      # slight race condition here, but it will only happen once
      row = AppSetting.new
      row.singleton_guard = 0
      allow_new_registration = true
      row.save!
      row
    end
  end


end