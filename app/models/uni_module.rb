class UniModule < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, length: { is: 8},:uniqueness => true


end
