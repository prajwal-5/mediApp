require 'csv'

class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :user

  def self.get_available_slots(current_doctor)
    previous_appointments = Appointment.select(:start_time).where(doctor_id: current_doctor.id).flat_map(&:start_time).map(&:to_datetime)
    available_appointment_slots = {}
    start_time = current_doctor.clinic_start_time.to_datetime
    close_time = current_doctor.clinic_end_time.to_datetime
    lunch_start_time = current_doctor.lunch_start_time.to_datetime
    lunch_end_time = current_doctor.lunch_end_time.to_datetime
    start_date = DateTime.now
    end_date = start_date + 7
    hour_step = (1.to_f / 24)

    (start_date..end_date).each do |date|
      available_time_slots = []
      start_time.step(close_time, hour_step).each do |time|
        time = time.change(:year => date.year, :month => date.month, :day => date.day)
        time_difference = ((time.to_datetime - DateTime.now) * 24 * 60 * 60)
        if time.wday!=0 && time_difference > 0 && ((time.hour < lunch_start_time.hour || time.hour >= lunch_end_time.hour) && time.hour != close_time.hour)
          available_time_slots.push(time)
        end
      end
      available_time_slots -= previous_appointments #- @available_time_slots
      if available_time_slots != []
        available_appointment_slots[date] = available_time_slots
      end
    end
    available_appointment_slots
  end
end
