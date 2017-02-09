FactoryGirl.define do
  factory :tagging do
    tag_id 1
    uni_module_id 1
  end
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
end
