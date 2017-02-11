# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

prp = UniModule.create(name: "Programming Practice", code: "4ccs1pra")
pra = UniModule.create(name: "Programming with Practical Applications", code: "4ccs1prp")
fc1 = UniModule.create(name: "Foundations of Computing 1", code: "4ccs1fc1")
cs1 = UniModule.create(name: "Computer Systems", code: "4ccs1cs1")
iai = UniModule.create(name: "Artificial Intelligence", code: "4ccs1iai")
dst = UniModule.create(name: "Data Structures", code: "4ccs1dst")
dbs = UniModule.create(name: "Database Systems", code: "4ccs1dbs")
ela = UniModule.create(name: "Elementary Logic With Applications", code: "4ccs1ela")
ins = UniModule.create(name: "Internet Systems", code: "5ccs2ins")
fc2 = UniModule.create(name: "Foundations of Computing 2", code: "5ccs2fc2")

programming = InterestTag.create(name: "Programming")
maths = InterestTag.create(name: "Maths")
robotics = InterestTag.create(name: "Robotics")
algorithms = InterestTag.create(name: "Algorithms")
artificial_intelligence = InterestTag.create(name: "Artificial Intelligence")
software_engineer = CareerTag.create(name: "Software Engineer")
network_engineer = CareerTag.create(name: "Network Engineer")
logic_engineer = CareerTag.create(name: "Logic Engineer")
database_engineer = CareerTag.create(name: "Database Engineer")
hardware_engineer = CareerTag.create(name: "Database Engineer")
front_end_developer = CareerTag.create(name: "Front-end Developer")

prp.tags << programming
pra.tags << programming
fc1.tags << maths
fc2.tags << maths
iai.tags << robotics
dst.tags << algorithms
fc2.tags << algorithms
iai.tags << artificial_intelligence
prp.tags << software_engineer
pra.tags << software_engineer
ins.tags << network_engineer
ela.tags << logic_engineer
dbs.tags << database_engineer
cs1.tags << hardware_engineer
pra.tags << front_end_developer


# User seeds
User.create!(first_name:  "Bob",
             last_name:   "Ross",
						 email:       "example@example.com",
						 password: 							"foobar",
						 password_confirmation: "foobar",
             user_level: 3,
             year_of_study: 1)
