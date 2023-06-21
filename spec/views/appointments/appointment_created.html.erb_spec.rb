require 'rails_helper'

RSpec.describe "appointments/appointment_created", type: :view do
  before(:each) do
    user = User.new({name: "PRajwal", email: "19bcs1010@cuchd.in", currency: "INR"})
    user.save
    doctor = Doctor.new({ name: "Doctor one", address: "Address one, City1, State1", image_url: "app/assets/images/doctor1.jpeg" })
    doctor.save
    @appointment = Appointment.new({user_id: user, doctor_id: doctor, start_time: doctor.clinic_start_time, end_time: doctor.clinic_start_time + 1.hour, cost: "500 INR"})
    @appointment.save
    assign(:current_user, user)
    assign(:time, @appointment.start_time)
  end

  it "renders appointments in my appointments" do
    render
    expect(rendered).to match(/#{Regexp.escape(@appointment.start_time.strftime("%I:%M %p"))}/)
  end
end
