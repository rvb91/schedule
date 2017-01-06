class Slot < ApplicationRecord

  # belongs_to :family
  # belongs_to :nanny

  START_BUFFER = 15.minutes
  MINIMUM_DURATION = 30.minutes

  validates :start_time, presence: true
  validates :end_time, presence: true#, numericality: { greater_than:  }

  validate :cannot_be_in_past, on: :create
  validate :end_must_greater_than_start

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

  def can_change_start_time?
    !family_id.present?
  end

end
