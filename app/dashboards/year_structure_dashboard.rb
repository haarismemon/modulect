require "administrate/base_dashboard"

class YearStructureDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
      course: Field::BelongsTo,
      groups: Field::HasMany,
      id: Field::Number,
      year_of_study: EnumField,
      created_at: Field::DateTime,
      updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
      :course,
      :year_of_study
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
      :course,
      :groups,
      :id,
      :year_of_study,
      :created_at,
      :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
      :course,
      :groups,
      :year_of_study,
  ].freeze

  # Overwrite this method to customize how year structures are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(year_structure)
    year_structure.to_s
  end
end
