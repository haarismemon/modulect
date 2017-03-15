# Build mock objects for testing purposes here.
# The name of a factory needs to be the same as the model's that it is building.
FactoryGirl.define do
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
    total_credits 120
    year_structure
  end

  factory :year_structure do
    year_of_study 1
    course
  end

  factory :course do
    name "BA Geography"
    year 2016
  end

  factory :department do
    name "Mathematics"
    faculty
  end

  factory :faculty do
    name "Natural and Mathematical Sciences"
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
    name          "Programming Applications"
    code          "4CCS1PRA"
    description   "PRA is aimed to further develop the Java programming
                  skills of first year students"
    lecturers     "Dr. Steffen Zschaler, Dr. Martin Chapman"
    semester      "2"
    credits       15
  end

  factory :user do
    first_name              "Allison"
    last_name               "Wonderland"
    email                   "allison_wonderland@kcl.ac.uk"
    password                "password"
    password_confirmation   "password"
    activated               true
    activated_at            Time.zone.now
    user_level              :user_access
  end

  factory :pathway do
    data "1:23;45/2:37;38#"
  end

end
