class UniModule < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, length: { is: 8},:uniqueness => true

  has_and_belongs_to_many :users
  has_and_belongs_to_many :tags

  scope :search, lambda {|tag|
    joins(:tags).where(["tags.name = ?", tag])
  }

  def self.basic_search(tags_array)
    # store the search results in hash. modules => [array of tags matched]
    results = {}

    # for each tag, search for the modules that contain the tag name
    tags_array.each do |tag_name|
      # store the tag object relating to the tag name
      tag = Tag.find_by_name(tag_name)
      if tag
        search(tag_name).each do |uni_module|
          # if the module was previously matched with a tag, store the current tag to the module's matched tags
          if results.key?(uni_module)
            matched_tags_array = results[uni_module]
            matched_tags_array << tag
            results[uni_module] = matched_tags_array
            # if this is first matched tag, then store the tag in an array
          else
            results[uni_module] = [tag]
          end
        end
      end
    end

    return results
  end

end
