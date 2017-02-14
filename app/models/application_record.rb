class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  #orders collection by order of attribute specified
  scope :alphabetically_order_by, lambda{|attribute_to_sort_by| order(attribute_to_sort_by)}
end
