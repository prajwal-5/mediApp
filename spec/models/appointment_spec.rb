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
      @available_slots.each do |date, slots|
        slots.each do |slot|
          if @current_doctor.lunch_start_time.hour > slot.hour && @current_doctor.lunch_end_time.hour < slot.hour
            raise "slot time cannot intersect with lunch time"
          end
        end
      end
    rescue RuntimeError => e
      expect(e.message).not_to include 'slot time cannot intersect with lunch time'
    end

    it 'should check no slot is after working hours' do
      @available_slots.each do |date, slots|
        slots.each do |slot|
          if @current_doctor.clinic_start_time.hour > slot.hour || @current_doctor.clinic_end_time.hour < slot.hour
            raise "slot time cannot be after working hours"
          end
        end
      end
    rescue RuntimeError => e
      expect(e.message).not_to include 'slot time cannot be after working hours'
    end
  end
end
