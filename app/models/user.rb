class User < ApplicationRecord

  attr_accessor :remember_token, :activation_token, :reset_token
  attr_accessor :updating_password

  before_save :downcase_email
  before_create :create_activation_digest

  # A user has many saved modules.
  has_many :saved_modules
  has_many :uni_modules, through: :saved_modules
  # A user has many pathways
  has_many :pathways
  # A user makes many comments
  has_many :comments
  # A user likes many comments
  has_and_belongs_to_many :liked_comments, class_name: 'Comment'

  # do not remove the , optional: true
  belongs_to :faculty, optional: true
  belongs_to :course, optional: true
  belongs_to :department, optional: true

  validates :first_name, presence: true, length: { maximum: 70 }
  validates :last_name, presence: true, length: { maximum: 70 }
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@kcl.ac.uk/i
  validates :email, presence: true,
            length: { maximum: 255 },
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }
  validates :year_of_study, length: { maximum: 1 }
  validates :course_id, length: { maximum: 1 } #not tested
  enum user_level: {user_access: 3, department_admin_access: 2, super_admin_access: 1 }
  has_secure_password
  validates :password, presence: true,
            length: {minimum: 6},
            if: :should_validate_password?

  default_value_for :user_level, :user_access

  class << self
    # Returns the hash digest of a given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
          BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Generates a new random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Registers the valid_uni_module as having been saved by this user.
  def save_module(valid_uni_module)
    uni_modules << valid_uni_module
  end

  # Removes the valid_uni_module as having been de-selected by this user (unsaved).
  def unsave_module(valid_uni_module)
    uni_modules.delete(valid_uni_module)
  end

  # Marks the user as persistenly logged in.
  # This method handles the server-side part of a persistent login by saving
  # the digest of a user's unique remember token, similar to how passwords are
  # handled.
  # Placing permanent cookies on the user's machine is also necessary.
  # See SessionsHelper#remember for the full mechanism of persistent logins.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forgets the unique token that allows a user to be persistently logged in.
  # It is also good practice to remove any client-side cookies along with
  # calling this method.
  # See SessionsHelper#forget for the full mechanism of forgetting a user.
  def forget
    update_attribute(:remember_token, nil)
  end

  # Checks whether the digest correlated to a given attribute matches the one
  # generated from the passed authentication_token.
  # The attribute is a symbol or string correlating to a database attribute_digest.
  # i.e. passing :remember as the attribute will correlate to remember_digest.
  # The authentication_token is the user-unique token that is used to check
  # authenticity.
  def authenticated?(attribute, authentication_token)
    return false if authentication_token.nil?
    digest = send("#{attribute}_digest")
    return digest != nil &&
           BCrypt::Password.new(digest).is_password?(authentication_token)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest) == password
  end

  # Reset a student user's attributes
  def reset
    update_attributes(year_of_study: nil,
                      faculty_id: nil,
                      department_id: nil,
                      course_id: nil)

    self.uni_modules.each do |uni_module|
      unsave_module(uni_module)
    end

    self.pathways.each do |pathway|
      self.pathways.delete(pathway)
    end
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sets the password digest attribute.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Sends the password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #format first and second name of user into a string
  def full_name
    "#{first_name} #{last_name}"
  end

  def department_admin?
    user_level == "department_admin_access" && self.department != nil
  end

  private
  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def should_validate_password?
    updating_password || new_record?
  end

  def self.to_csv
    base_attributes = %w{first_name last_name}
    csv_header = ['First Name', 'Last Name', 'Faculty', 'Course', 'Department']

    CSV.generate(headers:true) do |csv|
      csv << csv_header.each { |att| att.titleize }
      all.each do |user|
        to_append = user.attributes.values_at(*base_attributes)

        to_append.push user.faculty.to_s
        to_append.push user.course.to_s
        to_append.push user.department.to_s

        csv << to_append
      end
    end
  end
end
