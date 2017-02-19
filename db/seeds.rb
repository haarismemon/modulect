# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# pass rates are all fictional, assigned to help with sorting according to pass rate
prp = UniModule.create(name: "Programming Practice", code: "4CCS1PRP", semester: "1",
                       credits: 15, pass_rate: 40)
pra = UniModule.create(name: "Programming Applications", code: "4CCS1PRA", semester: "2",
											 credits: 15, exam_percentage: 75, coursework_percentage: 25, pass_rate: 50)
fc1 = UniModule.create(name: "Foundations of Computing 1", code: "4CCS1FC1", semester: "1",
											 credits: 15, exam_percentage: 90, coursework_percentage: 10)
cs1 = UniModule.create(name: "Computer Systems", code: "4CCS1CS1", semester: "1",
											 credits: 15, exam_percentage: 85, coursework_percentage: 15, pass_rate: 45)
iai = UniModule.create(name: "Artificial Intelligence", code: "4CCS1IAI", semester: "2",
											 credits: 15, exam_percentage: 70, coursework_percentage: 30)
dst = UniModule.create(name: "Data Structures", code: "4CCS1DST", semester: "2",
											 credits: 15, exam_percentage: 85, coursework_percentage: 15, pass_rate: 30)
dbs = UniModule.create(name: "Database Systems", code: "4CCS1DBS", semester: "2",
											 credits: 15, exam_percentage: 85, coursework_percentage: 15, pass_rate: 45)
ela = UniModule.create(name: "Elementary Logic With Applications", code: "4CCS1ELA", semester: "1",
											 credits: 15, pass_rate: 30)
ins = UniModule.create(name: "Internet Systems", code: "5CCS2INS", semester: "1",
											 credits: 15, exam_percentage: 80, coursework_percentage: 20, pass_rate: 60)
fc2 = UniModule.create(name: "Foundations of Computing 2", code: "5CCS2FC2", semester: "2",
											 credits: 15, exam_percentage: 100, coursework_percentage: 0, pass_rate: 70, requirements: "Must have done FC1 in 1st year")

programming = InterestTag.create(name: "Programming")
maths = InterestTag.create(name: "Maths")
robotics = InterestTag.create(name: "Robotics")
algorithms = InterestTag.create(name: "Algorithms")
artificial_intelligence = InterestTag.create(name: "Artificial Intelligence")
software_engineer = CareerTag.create(name: "Software Engineer")
network_engineer = CareerTag.create(name: "Network Engineer")
logic_engineer = CareerTag.create(name: "Logic Engineer")
database_engineer = CareerTag.create(name: "Database Engineer")
hardware_engineer = CareerTag.create(name: "Hardware Engineer")
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
User.create(first_name:  "Vlad",
            last_name:   "Nedelscu",
            email:       "nedelescu.vlad@gmail.com",
            password: 							"foobar",
            password_confirmation: "foobar",
            user_level: 3,
            year_of_study: 1
            )
User.create(first_name:  "Bob",
            last_name:   "Ross",
					  email:       "example@example.com",
					  password: 							"foobar",
					  password_confirmation: "foobar",
            activated: true,
            activated_at: Time.zone.now,
            user_level: 3,
            year_of_study: 1)

# Course seeds
computer_science_15 = Course.create(name: "BSc Computer Science", year: 2015)
maths = Course.create(name: "BSc Mathematics", year: 2015)
jmc = Course.create(name: "BSc Joint Mathematics and Computer Science", year: 2015)
elec_eng = Course.create(name: "BSc Electronic Engineering", year: 2015)
medicine = Course.create(name: "Medicine", year: 2015)

# Department seeds
informatics = Department.create(name: "Informatics")
mathematics = Department.create(name: "Mathematics")
physics = Department.create(name: "Physics")
chemistry = Department.create(name: "Chemistry")
gkt = Department.create(name: "GKT School of Medical Education")

# Faculty seed
nms = Faculty.create(name: "Natural and Mathematical Sciences")
lsm = Faculty.create(name: "Life Sciences and Medicine")

# Faculty-Department One to many assocation
nms.departments << informatics
nms.departments << mathematics
nms.departments << physics
nms.departments << chemistry
lsm.departments << gkt

# Department-Course many to many association
informatics.courses << computer_science_15
mathematics.courses << maths
mathematics.courses << jmc
informatics.courses << elec_eng
gkt.courses << medicine

# Year Structure seeds
cs_year1 = YearStructure.create(year_of_study: 1)
cs_year2 = YearStructure.create(year_of_study: 2)

# Course-YearStructure association
computer_science_15.year_structures << cs_year1
computer_science_15.year_structures << cs_year2

# Group seeds
cs1_semester_1 = Group.create(name: "Semester 1", total_credits: 60)
cs1_semester_2 = Group.create(name: "Semester 2", total_credits: 60)
cs2_semester_1 = Group.create(name: "Semester 1", total_credits: 60)
cs2_semester_2 = Group.create(name: "Semester 2", total_credits: 60)

maths_group = Group.create(name: "Maths", total_credits: 60)

# Group-Modules association
cs1_semester_1.uni_modules << prp
cs1_semester_1.uni_modules << ela
cs1_semester_1.uni_modules << fc1
cs1_semester_1.uni_modules << cs1
cs1_semester_2.uni_modules << pra
cs1_semester_2.uni_modules << dst
cs1_semester_2.uni_modules << dbs
cs1_semester_2.uni_modules << iai
cs2_semester_1.uni_modules << ins
cs2_semester_2.uni_modules << fc2

maths_group.uni_modules << fc1
maths_group.uni_modules << ela

# Group-YearStructure association
cs_year1.groups << cs1_semester_1
cs_year1.groups << cs1_semester_2
cs_year2.groups << cs2_semester_1
cs_year2.groups << cs2_semester_2

cs_year1.groups << maths_group
