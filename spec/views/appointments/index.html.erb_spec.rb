require 'rails_helper'

RSpec.describe "appointments/index", type: :view do
  before(:each) do
    assign(:appointments, [
      Appointment.create!(
        cost: "9.99"
      ),
      Appointment.create!(
        cost: "9.99"
      )
    ])
  end

  it "renders a list of appointments" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
  end
end
