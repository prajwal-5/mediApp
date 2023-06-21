require 'rails_helper'

RSpec.describe "appointments/index", type: :view do
  before :each do
    current_doctor = Doctor.new({ name: "Doctor one", address: "Address one, City1, State1", image_url: "doctor1.jpeg" })
    current_doctor.save
    assign(:current_doctor, current_doctor)
    assign(:available_appointment_slots, Appointment.get_available_slots(current_doctor))
    assign(:slot, nil)
  end

  it 'should check for index view time is rendered' do
    render
    expect(rendered).to match(/PM/)
  end
end
