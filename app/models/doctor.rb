class Doctor < ApplicationRecord
  has_many :appointments
  has_many :users, through: :appointments
  after_initialize :init

  def init
    self.clinic_start_time ||= set_date(Time.zone.parse("2023-5-17 12:00:00"))
    self.clinic_end_time ||= set_date(Time.zone.parse("2023-5-17 16:00:00"))
    self.lunch_start_time ||= set_date(Time.zone.parse("2023-5-17 13:00:00"))
    self.lunch_end_time ||= set_date(Time.zone.parse("2023-5-17 14:00:00"))
  end

  def get_first_available_slot
    Appointment.get_available_slots(self).values.first.first
  end

  private
  def set_date(time)
    current_date = Time.zone.now
    time.change(year: current_date.year, month: current_date.month, day: current_date.day)
  end
end
