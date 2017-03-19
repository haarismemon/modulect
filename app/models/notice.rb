class Notice < ApplicationRecord
  require 'uri'


  # belongs to a department
  belongs_to :department, :optional => true

  # every object must validate presence of title
  # and notice body fields before saving
  validates :header, presence: true
  validates :notice_body, presence: true
  validates :live_date, presence: true

  # format of link must be correct before saving
  validates :optional_link, format: {with: URI::regexp, :message => "is not a valid url"}, :allow_blank => true

  # sets default value for broadcast attribute to true
  default_value_for :broadcast, true

  # sets default value for live_date
  default_value_for :live_date, Date.current

  # sets default value for auto_delete attribute to true
  default_value_for :auto_delete, true

  validate 'end_date_can_not_be_before_current_date'.to_s
  validate 'end_date_can_not_be_before_the_live_date'.to_s

  # validation to check end date is not before the current date
  def end_date_can_not_be_before_current_date
    if !end_date.nil? && end_date.past?
      errors.add(:expire_date, "is before the current date")
    end
  end

  # validation to check end date is not before the live date
  def end_date_can_not_be_before_the_live_date
    if !end_date.nil? && end_date<live_date
      errors.add(:expire_date, "is before the live start date")
    end
  end


end
