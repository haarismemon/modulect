# Build mock objects for testing purposes here.
# The name of a factory needs to be the same as the model's that it is building.
FactoryGirl.define do
  factory :group do
    name "MyString"
    total_credits 1
    year_structure nil
  end
  factory :year_structure do
    year_of_study 1
    course nil
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
    email                   "allison_wonderland@eemail.com"
    password                "password"
    password_confirmation   "password"
    activated               true
    activated_at            Time.zone.now
    user_level              3
    entered_before          false
  end
end
