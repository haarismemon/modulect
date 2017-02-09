# Build mock objects for testing purposes here.
# The name of a factory needs to be the same as the model's that it is building.
FactoryGirl.define do
  factory :tag do
    name "Arbitrary Tag"
    type "Career"
  end

  factory :career do
    name "Software Engineer"
  end

  factory :interest do
    name "Medicine"
  end

  factory :uni_module do
    name "Programming Applications"
    code "4CCS1PRA"
    description "PRA is aimed to further develop the Java programming
    skills of first year students"
    lecturers "Dr. Steffen Zschaler, Dr. Martin Chapman"
  end

  factory :tagging do
    tag
    uni_module
  end
end
