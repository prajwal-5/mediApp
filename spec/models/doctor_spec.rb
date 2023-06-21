require 'rails_helper'

RSpec.describe Doctor, type: :model do
  before :all do
    START_TIME_HOUR = 12
    END_TIME_HOUR =16
    LUNCH_START_TIME_HOUR = 13
    LUNCH_END_TIME_HOUR = 14
    @current_doctor = Doctor.new({ name: "Doctor one", address: "Address one, City1, State1", image_url: "doctor1.jpeg" })
    @available_slots = Appointment.get_available_slots(@current_doctor)
  end

  describe "Doctor" do
    it 'should check created doctor gets default clinic_start_time' do
      expect(@current_doctor.clinic_start_time.hour).to eql START_TIME_HOUR
    end

    it 'should check created doctor gets default clinic_end_time' do
      expect(@current_doctor.clinic_end_time.hour).to eql END_TIME_HOUR
    end

    it 'should check created doctor gets default clinic_lunch_time' do
      expect(@current_doctor.lunch_start_time.hour).to eql LUNCH_START_TIME_HOUR
    end

    it 'should check created doctor gets default clinic_lunch_time' do
      expect(@current_doctor.lunch_end_time.hour).to eql LUNCH_END_TIME_HOUR
    end
  end

  describe 'Get first available slot' do
    it 'should get the default first available slot' do
      first_available_slots = Doctor.get_first_available_slot(Array.new([@current_doctor]))
      expect(first_available_slots[@current_doctor].hour).to eql START_TIME_HOUR
    end
  end
end
