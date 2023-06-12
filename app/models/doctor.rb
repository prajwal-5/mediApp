class Doctor < ApplicationRecord
  has_many :appointments
  has_many :users, through: :appointments
  after_initialize :init

  def init
    self.clinic_start_time ||= Time.zone.parse("2023-5-17 12:00:00")
    self.clinic_end_time ||= Time.zone.parse("2023-5-17 16:00:00")
    self.lunch_start_time ||= Time.zone.parse("2023-5-17 13:00:00")
    self.lunch_end_time ||= Time.zone.parse("2023-5-17 14:00:00")
  end
end
