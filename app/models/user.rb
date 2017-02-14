class User < ApplicationRecord

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  has_and_belongs_to_many :uni_modules

  validates :first_name, presence: true, length: { maximum: 70 }
  validates :last_name, presence: true, length: { maximum: 70 }
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255 },
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  validates :user_level, length: { is: 1 }, inclusion: { in: [1, 2, 3] }
  validates :year_of_study, length: { maximum: 1 }

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  default_value_for :user_level, 3  #student #(needs testing)
  default_value_for :entered_before, false  #(needs testing)


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
    BCrypt::Password.new(digest).is_password?(authentication_token)
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

  private
  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
