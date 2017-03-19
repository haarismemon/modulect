class Faculty < ApplicationRecord

  validates :name, presence: true, uniqueness: true
  has_many :users
  has_many :departments

  def self.to_csv
    attributes = %w{name}
    CSV.generate(headers:true)do |csv|
      csv << %w(Name Departments)
      all.each do |faculty|
        deptNames = ''
        Department.where(:faculty_id => faculty.id).each { |dept| deptNames += dept.name + '; '}
        deptNames.chop!.chop!
        csv << faculty.attributes.values_at(*attributes) + [*deptNames]
      end
    end
  end
end
