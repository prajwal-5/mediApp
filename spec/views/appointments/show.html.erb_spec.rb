require 'rails_helper'

RSpec.describe "appointments/show", type: :view do
  before(:each) do
    assign(:appointment, Appointment.create!(
      cost: "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/9.99/)
  end
end
