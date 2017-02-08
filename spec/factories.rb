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
end
