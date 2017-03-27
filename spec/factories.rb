# Build mock objects for testing purposes here.
# The name of a factory needs to be the same as the model's that it is building.
FactoryGirl.define do
  factory :tag_log do
    
  end
  factory :uni_module_log do
    
  end
  factory :search_log do
    
  end
  factory :visitor_log do
    
  end
  factory :saved_module do
    
  end
  factory :app_setting do
    is_offline false
    offline_message "MyString"
    allow_new_registration false
  end

  factory :group do
    name "Semester 1"
    min_credits 60
    max_credits 60
    year_structure
  end

  factory :year_structure do
    year_of_study 1
    course
  end

  factory :course do
    name "BA Geography with not Applications"
    year 2016
  end

  factory :department do
    name "Mathematics with Applications"
    faculty
  end

  factory :faculty do
    name "Natural and Mathematical Sciences at Kings"
  end

  factory :tag do
    name "Arbitrary Tag"
    type "CareerTag"
  end

  factory :career_tag do
    name "Software Engineer"
  end

  factory :interest_tag do
    name "Medicine"
  end

  factory :uni_module do
    name          "Philosophy and its Applications"
    code          "6CCS1PHA"
    description   "Philosphy is not a trivial subject for real life"
    lecturers     "Dr. Steffen Zschaler, Dr. Martin Chapman"
    semester      "2"
    credits       15
  end

  factory :user do
    first_name              "Allison"
    last_name               "Wonderland"
    email                   "allison.wonderland@kcl.ac.uk"
    password                "password"
    password_confirmation   "password"
    activated               true
    activated_at            Time.zone.now
    user_level              :user_access
  end

  factory :pathway do
    data "1:23;45/2:37;38#"
  end

  factory :suggested_pathway do
    name "Success Pathway"
    year 2015
    course
  end
end
