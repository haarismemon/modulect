class Faculty < ApplicationRecord

  validates :name, presence: true, uniqueness: true
  has_many :users
  has_many :departments

  # CSV export, loops over the faculty record obtaining the individual columns from the database
  def self.to_csv
    attributes = %w{name}
    CSV.generate(headers:true)do |csv|
      csv << %w(name departments)
      all.each do |faculty|
        deptNames = ''
        Department.where(:faculty_id => faculty.id).each { |dept| deptNames += dept.name + '; '}
        deptNames.chop!
        if deptNames!=''
          deptNames.chop!
        end
      end
    end
  end

  def to_s
    name
  end
end
