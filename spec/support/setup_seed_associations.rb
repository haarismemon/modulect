module SetupSeedAssociations
  def setup_seed_associations
   # Tag association
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

    nms.departments << informatics

    computer_science_15.year_structures << cs_year_1
    computer_science_15.year_structures << cs_year_2

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
    cs_year_1.groups << cs1_semester_1
    cs_year_1.groups << cs1_semester_2
    cs_year_2.groups << cs2_semester_1
    cs_year_2.groups << cs2_semester_2

    informatics.courses << computer_science_15
  end
end
