require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    uni_modules: Field::HasMany,
    id: Field::Number,
    first_name: Field::String,
    last_name: Field::String,
    email: Field::String,
    password_digest: Field::String,
    user_level: EnumField,
    entered_before: Field::Boolean,
    year_of_study: YearOfStudyField,
    course: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    remember_digest: Field::String,
    activation_digest: Field::String,
    activated: Field::Boolean,
    activated_at: Field::DateTime,
    reset_digest: Field::String,
    reset_sent_at: Field::DateTime,
  #  departments: Field::HasMany,
    faculty: Field::BelongsTo,
    password: PasswordField,
    password_confirmation: PasswordField,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :user_level,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
      :id,
    :first_name,
    :last_name,
    :email,
    :user_level,
    :year_of_study,
    :course,
  #  :departments,
    :created_at,
    :updated_at,
    :activated,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :first_name,
    :last_name,
    :user_level,
    :email,
    :password,
    :password_confirmation,
    :course,
    :year_of_study,
    #:departments,

  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    user.full_name
  end
end
