class Pathway < ApplicationRecord

  validates :data, presence: true

  # A pathway belongs to one user
  belongs_to :user, optional: true

end
