require 'rails_helper'
require 'support/upload_helper_steps'

RSpec.describe Admin::UploadHelper, type: :helper do
  include UploadHelperSteps

  fixtures :users
  fixtures :departments
  fixtures :courses
  fixtures :faculties

  describe "for courses" do
    let(:resource_name) { "courses" }
    let(:resource_header) { "name,description,year,duration_in_years,departments".split(',') }
    let(:uploader) { users(:super_admin) }

    context "when handling a single row" do
      let(:csv_text) { "name,description,year,duration_in_years,departments\nMyCourseKappa,,2015,3,Informatics\n" }

      it "can both create and upload" do
        expect{upload_csv(csv_text)}.to change{Course.count}.by(1)
        expect_creation_attemps(1)
        expect_no_update_attempts
        expect_no_errors

        csv_text = "name,description,year,duration_in_years,departments\nMyCourseKappa,,2015,4,Informatics\n" 

        expect{upload_csv(csv_text)}.to_not change{Course.count}
        expect_update_attempts(1)
        expect_no_creation_attempts
        expect_no_errors
      end
    end

    context "when handling multiple rows" do
      let(:csv_text) { "name,description,year,duration_in_years,departments\nMyCourseKappa,,2015,3,Informatics\nMySecondCourse,,2014,4,Informatics" }

      it "creates the records and updates as appropriate" do
        expect{upload_csv(csv_text)}.to change{Course.count}.by(2)
        expect_creation_attemps(2)
        expect_no_update_attempts
        expect_no_errors

        csv_text = "name,description,year,duration_in_years,departments\nMyCourseKappa,,2015,4,Informatics\n" 

        expect{upload_csv(csv_text)}.not_to change{Course.count}
        expect_update_attempts(1)
        expect_no_creation_attempts
        expect_no_errors
      end
    end
  end 

  describe "for modules" do
    let(:resource_name) { "uni_modules" }
    let(:resource_header) { "name,code,description,lecturers,pass_rate,assessment_methods,semester,credits,exam_percentage,coursework_percentage,more_info_link,assessment_dates,prerequisite_modules,career_tags,interest_tags,departments".split(',') }
    let(:uploader) { users(:super_admin) }

    context "when handling multiple rows" do

      let(:csv_text) { "name,code,description,lecturers,pass_rate,assessment_methods,semester,credits,exam_percentage,coursework_percentage,more_info_link,assessment_dates,prerequisite_modules,career_tags,interest_tags,departments\nShould add,8CCS2DSK,PLEASE CREATE,Kappa,80,Bananas,1,30,15,85,Kappa,YaKnow,,Informatics,Kappa,Informatics\nShould NOT,PLEASENO,,,,,2,15,,,,,INVALID MODULE,Informatics,Kappa,Chemistry\nShould add,8CCS2DSK,PLEASE UPDATE,,,,1,30,,,,,,Informatics,\"Kappa, Chocolates\",Informatics; Physics with Applications\n" }

      it "can both create and update" do
        expect{upload_csv(csv_text)}.to change{UniModule.count}.by(1)
        expect_creation_attemps(2)
        expect_update_attempts(1)
        expect_errors
        csv_text = "name,code,description,lecturers,pass_rate,assessment_methods,semester,credits,exam_percentage,coursework_percentage,more_info_link,assessment_dates,prerequisite_modules,career_tags,interest_tags,departments\nShould add,8CCS2DSK,Kappa,Kappa,80,Bananas,1,30,15,80,Kappa,YaKnow,,Informatics,Kappa,Informatics"
        expect{upload_csv(csv_text)}.to_not change{UniModule.count}
        expect_update_attempts(1)
        expect_no_creation_attempts
        expect_no_errors
      end
    end
  end

  describe "for departments" do
    let(:resource_name) { "departments" }
    let(:resource_header) { "name,faculty_name".split(',') }
    let(:uploader) { users(:super_admin) }

    context "when given a valid faculty" do
      let(:csv_text) { "name,faculty_name\nMathematika,Natural and Mathematical Sciences\n" }

      it "can create a department" do
        expect{upload_csv(csv_text)}.to change{Department.count}.by(1)
        expect_creation_attemps(1)
        expect_no_update_attempts
        expect_no_errors
      end
    end

    context "when given an invalid faculty" do
      let(:csv_text) { "name,faculty_name\nMathematika,Invalid Faculty\n" }
      it "does not create the faculty" do
        expect{upload_csv(csv_text)}.to_not change{Department.count}
        expect_errors
      end
    end
  end

  describe "for faculties" do
    let(:resource_name) { "faculties" }
    let(:resource_header) { "name,departments".split(',') }
    let(:uploader) { users(:super_admin) }

    context "when creating and adding a valid department" do
      let(:csv_text) { "name,departments\nMyFaculty,Informatics" }

      it "creates the faculty and associates the department" do
        expect{upload_csv(csv_text)}.to change{Faculty.count}.by(1)
        expect_creation_attemps(1)
        expect_no_errors
        expect(Faculty.last.departments.first.name).to eq "Informatics"
      end
    end

    context "when passed multiple valid departments" do
      let(:csv_text) { "name,departments\nMyFaculty,Informatics;Physics with Applications" }
      it "creates the faculty and associates the departments" do
        expect{upload_csv(csv_text)}.to change{Faculty.count}.by(1)
        expect_creation_attemps(1)
        expect_no_errors
        expect(Faculty.last.departments.count).to eq 2
      end
    end

    context "when passed a department that doesn't exist" do
      let(:csv_text) { "name,departments\nMyFaculty,Informatics;InvalidDepartment" }
      it "creates the faculty and the inexsitant department" do
        expect{upload_csv(csv_text)}.to change{Faculty.count}.by(1)
        expect_creation_attemps(1)
        expect_no_errors
        expect(Faculty.last.departments.count).to eq 2
      end
    end
  end
end 
