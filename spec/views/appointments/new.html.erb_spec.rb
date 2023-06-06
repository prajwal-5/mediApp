require 'rails_helper'

RSpec.describe "appointments/new", type: :view do
  before(:each) do
    assign(:appointment, Appointment.new(
      cost: "9.99"
    ))
  end

  it "renders new appointment form" do
    render

    assert_select "form[action=?][method=?]", appointments_path, "post" do

      assert_select "input[name=?]", "appointment[cost]"
    end
  end
end
