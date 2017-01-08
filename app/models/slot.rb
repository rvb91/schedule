class Slot < ApplicationRecord

  # belongs_to :family
  belongs_to :nanny

  START_BUFFER = 15.minutes
  MINIMUM_DURATION = 30.minutes

  validates :start_time, presence: true
  validates :end_time, presence: true

  # The ordering of these validations is important
  validate :cannot_be_in_past, on: :create
  validate :end_must_greater_than_start
  validate :no_overlaps

   scope :reserveable, -> { where(family_id: nil) }

  def can_reserve?
    family_id.nil?
  end

  def can_cancel?(user)
    family.id == user.family.id
  end

  def cannot_be_in_past
    return unless start_time
    if start_time < Time.now
      errors.add(:start_time, "cannot be in the past")
    end

    if start_time > Time.now && start_time < Time.now + START_BUFFER
      errors.add(:start_time, "slot must start atleast #{START_BUFFER.to_i/60} minutes from now")
    end
  end

  def end_must_greater_than_start
    return unless start_time && end_time
    if end_time < (start_time + MINIMUM_DURATION)
      errors.add(:end_time, "must be greater than start time")
    end
  end

  def no_overlaps
    return unless self.nanny
    found_overlaps = self.nanny.slots.where("start_time < ? AND ? < end_time", self.end_time, self.start_time).any?
    if found_overlaps
      errors.add(:start_time, "you already have a slot booked in this time period")
    end
  end

  def can_change_start_time?
    !family_id.present?
  end


end
