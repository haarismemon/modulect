# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# pass rates are all fictional, assigned to help with sorting according to pass rate
prp = UniModule.create(name: "Programming Practice", code: "4CCS1PRP", semester: "1",
                       credits: 15, pass_rate: 40, more_info_link:"http://www.kcl.ac.uk/nms/depts/informatics/study/current/handbook/progs/Modules/4CCS1PRP.aspx" )
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
											 credits: 15, exam_percentage: 100, coursework_percentage: 0, pass_rate: 70)

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

# Course seeds
computer_science_15 = Course.create(name: "BSc Computer Science", year: 2015)
mathem = Course.create(name: "BSc Mathematics", year: 2015)
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
mathematics.courses << mathem
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
cs1_semester_1 = Group.create(name: "Semester 1", total_credits: 60, compulsory: true)
cs1_semester_2 = Group.create(name: "Semester 2", total_credits: 60, compulsory: false)
cs2_semester_1 = Group.create(name: "Semester 1", total_credits: 60, compulsory: true)
cs2_semester_2 = Group.create(name: "Semester 2", total_credits: 60, compulsory: false)

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

# Group-YearStructure association
cs_year1.groups << cs1_semester_1
cs_year1.groups << cs1_semester_2
cs_year2.groups << cs2_semester_1
cs_year2.groups << cs2_semester_2

# Making up a course using optional modules groups

math_and_ph = Course.create(name: "Mathematics & Physics BSc", year: 2015)

mathematics.courses << math_and_ph

mnp_year1 = YearStructure.create(year_of_study: 1)
mnp_year2 = YearStructure.create(year_of_study: 2)
mnp_year3 = YearStructure.create(year_of_study: 3)

math_and_ph.year_structures << mnp_year1
math_and_ph.year_structures << mnp_year2
math_and_ph.year_structures << mnp_year3

mnp_year1_required_modules =   Group.create(name: "required", total_credits: 105, compulsory: true)
mnp_year2_required_modules =   Group.create(name: "required", total_credits: 90, compulsory: true)
mnp_year3_required_modules =   Group.create(name: "required", total_credits: 15, compulsory: true)
mnp_year1_optional_modules =   Group.create(name: "optional", total_credits: 15, compulsory: false)
mnp_year2_optional_modules_1 = Group.create(name: "optional", total_credits: 15, compulsory: false)
mnp_year2_optional_modules_2 = Group.create(name: "optional", total_credits: 15, compulsory: false)
mnp_year3_optional_modules_1 = Group.create(name: "optional", total_credits: 15, compulsory: false)
mnp_year3_optional_modules_2 = Group.create(name: "optional", total_credits: 15, compulsory: false)
mnp_year3_optional_modules_3 = Group.create(name: "optional", total_credits: 75, compulsory: false)

mnp_year1.groups << mnp_year1_required_modules
mnp_year2.groups << mnp_year2_required_modules
mnp_year3.groups << mnp_year3_required_modules

mnp_year1.groups << mnp_year1_optional_modules
mnp_year2.groups << mnp_year2_optional_modules_1
mnp_year2.groups << mnp_year2_optional_modules_2
mnp_year3.groups << mnp_year3_optional_modules_1
mnp_year3.groups << mnp_year3_optional_modules_2
mnp_year3.groups << mnp_year3_optional_modules_3

mnp_y1_req_1 =   UniModule.create(code: "4ACS2FC2", semester: "1", credits: 15, name: "Calculus I")
mnp_y1_req_2 =   UniModule.create(code: "4SCS2FC2", semester: "2", credits: 15, name: "Linear Methods")
mnp_y1_req_3 =   UniModule.create(code: "4DCS2FC2", semester: "1", credits: 15, name: "Calculus II")
mnp_y1_req_4 =   UniModule.create(code: "4FCS2FC2", semester: "2", credits: 15, name: "Fields and Waves")
mnp_y1_req_5 =   UniModule.create(code: "4GCS2FC2", semester: "1", credits: 15, name: "Thermal Physics")
mnp_y1_req_6 =   UniModule.create(code: "4HCS2FC2", semester: "2", credits: 15, name: "Matter")
mnp_y1_req_7 =   UniModule.create(code: "4JCS2FC2", semester: "2", credits: 15, name: "Joint Honours Laboratory")
mnp_y1_opt_1_1 = UniModule.create(code: "4KCS2FC2", semester: "1", credits: 15, name: "Numbers and Functions")
mnp_y1_opt_1_2 = UniModule.create(code: "4LCS2FC2", semester: "1", credits: 15, name: "Probability and Statistics I")

mnp_y1_req_1.tags << maths

mnp_year1_required_modules.uni_modules << mnp_y1_req_1
mnp_year1_required_modules.uni_modules << mnp_y1_req_2
mnp_year1_required_modules.uni_modules << mnp_y1_req_3
mnp_year1_required_modules.uni_modules << mnp_y1_req_4
mnp_year1_required_modules.uni_modules << mnp_y1_req_5
mnp_year1_required_modules.uni_modules << mnp_y1_req_6
mnp_year1_required_modules.uni_modules << mnp_y1_req_7

mnp_year1_optional_modules.uni_modules << mnp_y1_opt_1_1
mnp_year1_optional_modules.uni_modules << mnp_y1_opt_1_2

mnp_y2_req_1 =   UniModule.create(code: "5HCS0FC2", semester: "1", credits: 15, name: "Partial Differential Equations and Complex Variables")
mnp_y2_req_2 =   UniModule.create(code: "5HCS1FC2", semester: "1", credits: 15, name: "Intermediate Dynamics")
mnp_y2_req_3 =   UniModule.create(code: "5HCS2FC2", semester: "1", credits: 15, name: "Introduction to Abstract Algebra for Joint Honours")
mnp_y2_opt_1_1 = UniModule.create(code: "5HCS3FC2", semester: "1", credits: 15, name: "Analysis I")
mnp_y2_opt_1_2 = UniModule.create(code: "5HCS4FC2", semester: "1", credits: 15, name: "Applied Analytic Methods")
mnp_y2_req_4 =   UniModule.create(code: "5HCS5FC2", semester: "2", credits: 15, name: "Nuclear Physics")
mnp_y2_req_5 =   UniModule.create(code: "5HCS6FC2", semester: "2", credits: 15, name: "Quantum Mechanics I")
mnp_y2_req_6 =   UniModule.create(code: "5HCS7FC2", semester: "2", credits: 15, name: "Electromagnetism")
mnp_y2_opt_2_1 = UniModule.create(code: "5HCS8FC2", semester: "2", credits: 15, name: "Laboratory Physics II")
mnp_y2_opt_2_2 = UniModule.create(code: "5HCS9FC2", semester: "2", credits: 15, name: "Astrophysics")

mnp_year2_required_modules.uni_modules << mnp_y2_req_1
mnp_year2_required_modules.uni_modules << mnp_y2_req_2
mnp_year2_required_modules.uni_modules << mnp_y2_req_3
mnp_year2_required_modules.uni_modules << mnp_y2_req_4
mnp_year2_required_modules.uni_modules << mnp_y2_req_5
mnp_year2_required_modules.uni_modules << mnp_y2_req_6

mnp_year2_optional_modules_1.uni_modules << mnp_y2_opt_1_1
mnp_year2_optional_modules_1.uni_modules << mnp_y2_opt_1_2

mnp_year2_optional_modules_2.uni_modules << mnp_y2_opt_2_1
mnp_year2_optional_modules_2.uni_modules << mnp_y2_opt_2_2

mnp_y3_req_1 =    UniModule.create(code: "6HQS2FC2", semester: "2", credits: 15, name: "Statistical Mechanics")
mnp_y3_opt_1_1 = UniModule.create(code: "6HWS2FC2", semester: "2", credits: 15, name: "Advanced Quantum Mechanics")
mnp_y3_opt_1_2 = UniModule.create(code: "6HES2FC2", semester: "2", credits: 15, name: "Quantum Mechanics II")
mnp_y3_opt_2_1 = UniModule.create(code: "6HRS2FC2", semester: "2", credits: 15, name: "Third Year Project in Physics")
mnp_y3_opt_2_2 = UniModule.create(code: "6HTS2FC2", semester: "2", credits: 15, name: "Third Year Literature Review")
mnp_y3_opt_2_3 = UniModule.create(code: "6HYS2FC2", semester: "2", credits: 15, name: "University Ambassadors' Scheme")

mnp_year3_required_modules.uni_modules << mnp_y3_req_1

mnp_year3_optional_modules_1.uni_modules << mnp_y3_opt_1_1
mnp_year3_optional_modules_1.uni_modules << mnp_y3_opt_1_2

mnp_year3_optional_modules_2.uni_modules << mnp_y3_opt_2_1
mnp_year3_optional_modules_2.uni_modules << mnp_y3_opt_2_2
mnp_year3_optional_modules_2.uni_modules << mnp_y3_opt_2_3

mnp_y3_opt_3_01 = UniModule.create(code: "6QBS2FC2", semester: "1", credits: 15, name: "Linear Algebra")
mnp_y3_opt_3_02 = UniModule.create(code: "6WBS2FC2", semester: "1", credits: 15, name: "Mathematical Theory of Collective Behaviour")
mnp_y3_opt_3_03 = UniModule.create(code: "6EBS2FC2", semester: "1", credits: 15, name: "Topics in Mathematics")
mnp_y3_opt_3_04 = UniModule.create(code: "6RBS2FC2", semester: "1", credits: 15, name: "Real Analysis II")
mnp_y3_opt_3_05 = UniModule.create(code: "6TBS2FC2", semester: "1", credits: 15, name: "Complex Analysis")
mnp_y3_opt_3_06 = UniModule.create(code: "6YBS2FC2", semester: "1", credits: 15, name: "Topology")
mnp_y3_opt_3_07 = UniModule.create(code: "6UBS2FC2", semester: "1", credits: 15, name: "Mathematics Third Year Project")
mnp_y3_opt_3_08 = UniModule.create(code: "6IBS2FC2", semester: "1", credits: 15, name: "Rings and Modules")
mnp_y3_opt_3_09 = UniModule.create(code: "6OBS2FC2", semester: "1", credits: 15, name: "Numerical and Computational Methods")
mnp_y3_opt_3_10 = UniModule.create(code: "6PBS2FC2", semester: "1", credits: 15, name: "Mathematical Finance I: Discrete Time")
mnp_y3_opt_3_11 = UniModule.create(code: "6ABS2FC2", semester: "1", credits: 15, name: "Theory of Complex Networks")
mnp_y3_opt_3_12 = UniModule.create(code: "6SBS2FC2", semester: "1", credits: 15, name: "Geometry of Surfaces")
mnp_y3_opt_3_13 = UniModule.create(code: "6DBS2FC2", semester: "1", credits: 15, name: "Elementary Number Theory")
mnp_y3_opt_3_14 = UniModule.create(code: "6FBS2FC2", semester: "2", credits: 15, name: "Groups and Symmetries")
mnp_y3_opt_3_15 = UniModule.create(code: "6GBS2FC2", semester: "2", credits: 15, name: "Discrete Mathematics")
mnp_y3_opt_3_16 = UniModule.create(code: "6HBS2FC2", semester: "2", credits: 15, name: "Galois Theory")
mnp_y3_opt_3_17 = UniModule.create(code: "6JBS2FC2", semester: "2", credits: 15, name: "Mathematics Education and Communication")
mnp_y3_opt_3_18 = UniModule.create(code: "6KBS2FC2", semester: "2", credits: 15, name: "Mathematical Finance II: Continuous Time")
mnp_y3_opt_3_19 = UniModule.create(code: "6LBS2FC2", semester: "2", credits: 15, name: "Representation Theory of Finite Groups")
mnp_y3_opt_3_20 = UniModule.create(code: "6ZBS2FC2", semester: "2", credits: 15, name: "Mathematical Biology")
mnp_y3_opt_3_21 = UniModule.create(code: "6XBS2FC2", semester: "2", credits: 15, name: "Space-Time Geometry and General Relativity")
mnp_y3_opt_3_22 = UniModule.create(code: "6CBS2FC2", semester: "2", credits: 15, name: "Fundamentals of Biophysics and Nanotechnology")
mnp_y3_opt_3_23 = UniModule.create(code: "6VBS2FC2", semester: "2", credits: 15, name: "Optics")
mnp_y3_opt_3_24 = UniModule.create(code: "6BBS2FC2", semester: "2", credits: 15, name: "Introduction to Medical Imaging")
mnp_y3_opt_3_25 = UniModule.create(code: "6NBS2FC2", semester: "2", credits: 15, name: "Particle Physics")
mnp_y3_opt_3_26 = UniModule.create(code: "6MBS2FC2", semester: "2", credits: 15, name: "Solid State Physics")

mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_01
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_02
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_03
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_04
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_05
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_06
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_07
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_09
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_10
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_11
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_12
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_13
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_14
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_15
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_16
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_17
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_18
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_19
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_20
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_21
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_22
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_23
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_24
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_25
mnp_year3_optional_modules_3.uni_modules << mnp_y3_opt_3_26

# User seeds

# system admin
bob = User.create!(first_name:  "Bob",
            last_name:   "Ross",
            email:       "bob.ross@kcl.ac.uk",
            password: 	 "foobar",
            password_confirmation: "foobar",
            activated: true,
            activated_at: Time.zone.now,
            user_level: 1)

# department admin
sophie = User.create!(first_name:  "Ali",
            last_name:   "Syed",
            email:       "ali.syed@kcl.ac.uk",
            password: 	 "foobar",
            password_confirmation: "foobar",
            activated: true,
            activated_at: Time.zone.now,
            user_level: 2,
            faculty: nms,
            department: informatics)

# student
sophie = User.create!(first_name:  "Sophie",
            last_name:   "McDonald",
            email:       "sophie.mcdonald@kcl.ac.uk",
            password: 	 "foobar",
            password_confirmation: "foobar",
            activated: true,
            activated_at: Time.zone.now,
            user_level: 3)



# Department-uni_module seed
informatics.uni_modules << prp
informatics.uni_modules << pra
informatics.uni_modules << fc1
informatics.uni_modules << fc2
informatics.uni_modules << iai
informatics.uni_modules << dst
informatics.uni_modules << ins
informatics.uni_modules << ela
informatics.uni_modules << dbs
informatics.uni_modules << cs1

fac = Faculty.create(name: "Faculty of Life Sciences & Medicine")
dep = Department.create(name: "Department of Pharmacology and Therapeutics")
crs = Course.create(name: "Pharmacology BSc", year: 2015)


year1 = YearStructure.create(year_of_study: 1)
year2 = YearStructure.create(year_of_study: 2)
year3 = YearStructure.create(year_of_study: 3)

req_1_year_1 = Group.create(
	name: "Required modules", 
	total_credits: 120, 
	compulsory: true)
	req_1_year_1.uni_modules << UniModule.create(code: "4BBY1013", semester: "1", credits: 15, name: "Biochemistry")
	req_1_year_1.uni_modules << UniModule.create(code: "4BBY1020", semester: "1", credits: 15, name: "Chemistry for the Biosciences")
	req_1_year_1.uni_modules << UniModule.create(code: "4BBY1070", semester: "0", credits: 15, name: "Genetics and Molecular Biology")
	req_1_year_1.uni_modules << UniModule.create(code: "4BBY1030", semester: "1", credits: 15, name: "Cell Biology and Neuroscience")
	req_1_year_1.uni_modules << UniModule.create(code: "4CCYB010", semester: "3", credits: 30, name: "Fundamentals of Physiology and Anatomy")
	req_1_year_1.uni_modules << UniModule.create(code: "4BBY1040", semester: "2", credits: 15, name: "Fundamentals of Pharmacology")
	req_1_year_1.uni_modules << UniModule.create(code: "4AAA0001", semester: "2", credits: 15, name: "Skills for the Biosciences")
req_1_year_2 = Group.create(
	name: "Required modules", 
	total_credits: 90, 
	compulsory: true)
	req_1_year_2.uni_modules << UniModule.create(code: "5BBM0213", semester: "3", credits: 30, name: "Drugs & Disease B")
	req_1_year_2.uni_modules << UniModule.create(code: "5BBM0216", semester: "1", credits: 15, name: "Drug Discovery & Development")
	req_1_year_2.uni_modules << UniModule.create(code: "5BBM0218", semester: "2", credits: 15, name: "Physiology & Pharmacology of the Central Nervous System")
	req_1_year_2.uni_modules << UniModule.create(code: "5BBM0219", semester: "3", credits: 30, name: "Research Skills in Pharmacology")
opt_1_year_2 = Group.create(
	name: "Select 30 credits from a range of optional modules", 
	min_credits: 30,
	max_credits: 30, 
	compulsory: false)
	opt_1_year_2.uni_modules << UniModule.create(code: "5BBM0217", semester: "2", credits: 15, name: "Animal Models of Disease and Injury")
	opt_1_year_2.uni_modules << UniModule.create(code: "5BBL0210", semester: "0", credits: 15, name: "Endocrinology and Reproduction")
	opt_1_year_2.uni_modules << UniModule.create(code: "5BBB0206", semester: "0", credits: 15, name: "Tissue Pathology")
	opt_1_year_2.uni_modules << UniModule.create(code: "5BBA2040", semester: "2", credits: 15, name: "Psychology")
	opt_1_year_2.uni_modules << UniModule.create(code: "5BBB0230", semester: "1", credits: 15, name: "Gene Cloning & Expression A")
opt_1_year_3 = Group.create(
	name: "You are required to take one of the following modules", 
	min_modules: 1,
	max_modules:1,
	compulsory: false)
	opt_1_year_3.uni_modules << UniModule.create(code: "6BBM0314", semester: "3", credits: 30, name: "Cell & Molecular Pharmacology")
	opt_1_year_3.uni_modules << UniModule.create(code: "6BBM0329", semester: "3", credits: 30, name: "Cellular Basis of Drug Dependence")
# schema needs to be change to accomodate this
opt_2_year_3 = Group.create(
	name: "You are also required to take one of the following options", 
	min_modules: 1,
	max_modules:1,
	compulsory: false)
	opt_2_year_3.uni_modules << UniModule.create(code: "6BBM0309", semester: "3", credits: 30, name: "Pharmacology Research Project")
	opt_2_year_3.uni_modules << UniModule.create(code: "6AAA0001", semester: "0", credits: 15, name: "Pharmacology Library Project")
	opt_2_year_3.uni_modules << UniModule.create(code: "6AAA0002", semester: "3", credits: 30, name: "Project Design in Pharmacology")
	opt_2_year_3.uni_modules << UniModule.create(code: "6AAA0003", semester: "3", credits: 45, name: "Extended Pharmacology Research Project")
opt_3_year_3 = Group.create(
	name: "Take optional modules to bring their total credits for the year to 120",
	compulsory: false)
	opt_3_year_3.uni_modules << UniModule.create(code: "6BBM0324", semester: "0", credits: 15, name: "Cardiovascular Pharmacology")
	opt_3_year_3.uni_modules << UniModule.create(code: "6BBM0325", semester: "3", credits: 30, name: "Experimental Cardiovascular Pharmacology")
	opt_3_year_3.uni_modules << UniModule.create(code: "6BBM0326", semester: "0", credits: 15, name: "Pharmacology of Inflammation")
	opt_3_year_3.uni_modules << UniModule.create(code: "6BBM0327", semester: "3", credits: 30, name: "Experimental Pharmacology of Inflammation")
	opt_3_year_3.uni_modules << UniModule.create(code: "6BBM0331", semester: "0", credits: 15, name: "Pharmacology of Neurological & Psychiatric Disorders")
	opt_3_year_3.uni_modules << UniModule.create(code: "6BBM0310", semester: "3", credits: 30, name: "Drug Safety & Toxicology")
fac.departments << dep
dep.courses << crs
crs.year_structures << year1
crs.year_structures << year2
crs.year_structures << year3
year1.groups << req_1_year_1
year2.groups << req_1_year_2
year2.groups << opt_1_year_2
year3.groups << opt_1_year_3
year3.groups << opt_2_year_3
year3.groups << opt_3_year_3
