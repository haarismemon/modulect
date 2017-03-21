class UniModule < ApplicationRecord

  validates :name, presence: true
  validates :code, presence: true, length: { is: 8 }, uniqueness: true
  validates :semester, presence: true
  validates :credits, presence: true

  # A UniModule has been saved as a favourite by many users.
  has_many :saved_modules
  has_many :users, through: :saved_modules

  has_and_belongs_to_many :groups
  has_and_belongs_to_many :departments
  has_and_belongs_to_many :tags

  #A UniModule has many required modules and can be a requirement of many modules
  has_and_belongs_to_many(:uni_modules,
    :join_table => "uni_module_requirements",
    :foreign_key => "uni_module_id",
    :association_foreign_key => "required_uni_module_id")

  # A UniModule has many comments (reviews)
  has_many :comments

  scope :search, lambda {|tag|
    joins(:tags).where(["tags.name = ?", tag])
  }

  scope :all_modules_in_group, lambda {|group|
    joins(:groups).where(["groups.id = ?", group.id])
  }

  # Filters the array of tags for type CareerTag
  def career_tags
    Array(tags).keep_if  do |tag|
      tag.type == "CareerTag"
    end
  end

  # Filters the array of tags for type InterestTag
  def interest_tags
    Array(tags).keep_if  do |tag|
      tag.type == "InterestTag"
    end
  end

  # Registers this module as having been tagged with the valid_tag.
  def add_tag(valid_tag)
    tags << valid_tag
  end

  # Registers a user as having selected this module.
  def select_by_user(valid_user)
    users << valid_user
  end

  # Searches for Modules with matching tags passed in through an array
  def self.basic_search(tags_array)
    # store the search results in a hash. modules => [array of matched tags]
    results = {}

    module_match_array = []

    # for each tag, search for the modules that contain the tag name
    tags_array.each do |tag_name|
      # store the tag object relating to the tag name
      match_tag = Tag.find_by_name(tag_name)
      if match_tag
        search(tag_name).each do |uni_module|
          # if the module was previously matched with a tag, store the current tag to the module's matched tags
          if results.key?(uni_module)
            matched_tags_array = results[uni_module]
            matched_tags_array << match_tag.name
            results[uni_module] = matched_tags_array
          # if this is first matched tag, then store the tag in an array
          else
            results[uni_module] = [match_tag.name]
          end
        end
      # else if the tag is not found, try look for a matching module name or code
      else
        # find module by code
        match_module = UniModule.find_by_code(tag_name)

        # if module not found with code, then find with name
        unless match_module
          match_module = UniModule.find_by_name(tag_name)
        end

        # if module found with either code or name, then add module to array of matched tags
        if match_module
          # if the module was previously matched with a tag, store the current module to the module's matched tags
          if results.key?(match_module)
            matched_tags_array = results[match_module]
            matched_tags_array << match_module.code
            results[match_module] = matched_tags_array
          # if this is first matched tag, then store the module in an array
          else
            results[match_module] = [match_module.code]
          end

          # store the module in an array to keep track of which modules have been searched for
          unless module_match_array.include? match_module
            module_match_array << match_module
          end
        end

      end
    end

    # sorted array with elements containing a module and an array of matched tags
    results = results.sort_by {|key, value| value.size}.reverse

    # results that contain the modules that have only tags in the value list
    result_with_only_matched_tags = []
    # results that contain the modules that are searched for either by name or code, and also have tags in the value list
    result_with_matched_module = []

    # split the results into modules that have only matched tags, and modules that also have a module matched
    results.each do |result|
      result_module = result[0]
      if module_match_array.include? result_module
        result_with_matched_module << result
      else
        result_with_only_matched_tags << result
      end
    end

    # join the two results into one, with results with a module matched at the TOP
    if result_with_matched_module.empty? && result_with_only_matched_tags.empty?
      return []
    elsif result_with_matched_module.empty?
      return result_with_only_matched_tags
    elsif result_with_only_matched_tags.empty?
      return result_with_matched_module
    else
      return result_with_matched_module.concat result_with_only_matched_tags
    end

  end

  # Searches for Modules in a course and year with matching tags
  def self.pathway_search(tags_array, course)
    basic_results = basic_search(tags_array)
    pathway_results = []

    basic_results.each do |result|
      uni_module = result[0]
      groups_that_contain_module = Group.search_by_module(uni_module.code)

      groups_that_contain_module.each do |group|
        if group.year_structure && group.year_structure.course
          course_of_result_module = group.year_structure.course

          if course.id == course_of_result_module.id
            if pathway_results.exclude? result
              pathway_results << result
            end
          end

        end
      end
    end

    return pathway_results
  end

  def self.to_csv
    attributes = %w{name code description lecturers pass_rate assessment_methods semester credits exam_percentage coursework_percentage more_info_link assessment_dates prerequisite_modules}
    caps = []
    attributes.each{|att| caps.push att}
    %w(career_tags interest_tags departments).each{|att| caps.push att}
    CSV.generate(headers:true)do |csv|
      csv << caps
      all.each do |uni_module|
        career_tag_names = ' '
        interest_tag_names = ' '
        department_names = ' '
        uni_module.career_tags.pluck(:name).each{|tag| career_tag_names += tag + '; ' }
        uni_module.interest_tags.pluck(:name).each{|tag| interest_tag_names += tag + '; ' }
        uni_module.departments.pluck(:name).each{|department| department_names += department + '; ' }
        career_tag_names.chop!
        if career_tag_names!=''
          career_tag_names.chop!
          career_tag_names[0] = ''
        end
        interest_tag_names.chop!
        if interest_tag_names!=''
          interest_tag_names.chop!
          interest_tag_names[0] = ''
        end
        department_names.chop!
        if department_names!=''
          department_names.chop!
          department_names[0] = ''
        end
        to_add = uni_module.attributes.values_at(*attributes) + [*career_tag_names] + [*interest_tag_names] + [*department_names]
        csv << to_add
      end
    end
  end

  def to_s
    "#{self.code} #{self.name}"
  end
end
