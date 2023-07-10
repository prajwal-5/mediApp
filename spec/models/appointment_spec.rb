require 'rails_helper'

RSpec.describe Appointment, type: :model do
  before :all do
    LAST_SLOT = 3
    DAYS_INCLUDING_TODAY = 8
    DAYS_EXCLUDING_TODAY = 7
    ALLOWED_BOOKING_DAYS = (Time.now.hour > LAST_SLOT) ? DAYS_EXCLUDING_TODAY : DAYS_INCLUDING_TODAY
    @current_doctor = Doctor.new({ name: "Doctor one", address: "Address one, City1, State1", image_url: "doctor1.jpeg" })
    @available_slots = Appointment.get_available_slots(@current_doctor)
  end

  describe "appointment" do
    it 'should check available slots are in a hash' do
      expect(@available_slots.class).to eql Hash
    end

    it 'should check slots are available for next seven days' do
      expect(@available_slots.length).to eql ALLOWED_BOOKING_DAYS
    end

    it 'should check no slot is between lunch break' do
      invalid_slots = @available_slots.values.flatten.select { |slot| @current_doctor.lunch_start_time.hour > slot.hour && @current_doctor.lunch_end_time.hour < slot.hour }
      expect(invalid_slots).to be_empty
    end

    it 'should check no slot is after working hours' do
      invalid_slots = @available_slots.values.flatten.select { |slot| @current_doctor.clinic_start_time.hour > slot.hour || @current_doctor.clinic_end_time.hour < slot.hour }
      expect(invalid_slots).to be_empty
    end
  end
end
