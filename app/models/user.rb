class User < ApplicationRecord

  validates :first_name, presence: true, length: { maximum: 70 }

  validates :last_name, presence: true, length: { maximum: 70 }

  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255 },
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }

  validates :username, presence: true, uniqueness: true

  validates :user_level, length: { is: 1 }, inclusion: { in: [1, 2, 3] }

  validates :year_of_study, presence: true,
                            length: { is: 1 },
                            inclusion: { in: [1, 2, 3, 4, 5, 6] }

  has_and_belongs_to_many :uni_modules

  # Registers the valid_uni_module as having been selected by this user.
  def select_module(valid_uni_module)
    uni_modules << valid_uni_module
  end
end
