require 'rails_helper'

RSpec.describe "appointments/edit", type: :view do
  let(:appointment) {
    Appointment.create!(
      cost: "9.99"
    )
  }

  before(:each) do
    assign(:appointment, appointment)
  end

  it "renders the edit appointment form" do
    render

    assert_select "form[action=?][method=?]", appointment_path(appointment), "post" do

      assert_select "input[name=?]", "appointment[cost]"
    end
  end
end
