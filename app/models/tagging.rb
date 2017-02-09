# Join model for associating between tags and uni modules
class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :uni_module

  # Both the tag_id and uni_module_id are validated to be present by default
end
