class UniModule < ApplicationRecord

  validates :name, presence: true
  validates :code, presence: true, length: { is: 8 }, uniqueness: true

  has_and_belongs_to_many :users
  has_and_belongs_to_many :tags

  scope :search, lambda {|tag|
    joins(:tags).where(["tags.name = ?", tag])
  }

  # Registers this module as having been tagged with the valid_tag.
  def add_tag(valid_tag)
    tags << valid_tag
  end

  # Registers a user as having selected this module.
  def add_user(valid_user)
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
          if results.key?(uni_module.name)
            matched_tags_array = results[uni_module.name]
            matched_tags_array << match_tag.name
            results[uni_module.name] = matched_tags_array
          # if this is first matched tag, then store the tag in an array
          else
            results[uni_module.name] = [match_tag.name]
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
          if results.key?(match_module.name)
            matched_tags_array = results[match_module.name]
            matched_tags_array << match_module.name
            results[match_module.name] = matched_tags_array
          # if this is first matched tag, then store the module in an array
          else
            results[match_module.name] = [match_module.name]
          end

          # store the module in an array to keep track of which modules have been searched for
          unless module_match_array.include? match_module.name
            module_match_array << match_module.name
          end
        end

      end
    end

    # sorted array with elements containing a module and an array of matched tags
    results = Array(results.sort_by {|key, value| value.size}.reverse)

    result_with_matched_module = []
    result_with_only_matched_tags = []

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
    return result_with_matched_module << result_with_only_matched_tags

  end

end
