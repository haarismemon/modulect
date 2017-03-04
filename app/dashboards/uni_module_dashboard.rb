require "administrate/base_dashboard"

class UniModuleDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    users: Field::HasMany,
    groups: Field::HasMany,
    departments: Field::HasMany,
    tags: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    code: Field::String,
    description: Field::String,
    lecturers: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    pass_rate: Field::String,
    assessment_methods: Field::String,
    semester: Field::String,
    credits: Field::Number,
    exam_percentage: Field::Number,
    coursework_percentage: Field::Number,
    requirements: Field::String,
    more_info_link: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :code,
    :lecturers
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :users,
    :groups,
    :departments,
    :tags,
    :id,
    :name,
    :code,
    :description,
    :lecturers,
    :created_at,
    :updated_at,
    :pass_rate,
    :assessment_methods,
    :semester,
    :credits,
    :exam_percentage,
    :coursework_percentage,
    :more_info_link,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :users,
    :groups,
    :departments,
    :tags,
    :name,
    :code,
    :description,
    :lecturers,
    :pass_rate,
    :assessment_methods,
    :semester,
    :credits,
    :exam_percentage,
    :coursework_percentage,
    :more_info_link,
  ].freeze

  # Overwrite this method to customize how uni modules are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(uni_module)
    uni_module.name
  end
end
