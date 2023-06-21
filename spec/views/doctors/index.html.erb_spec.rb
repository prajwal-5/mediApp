require 'rails_helper'

RSpec.describe "doctors/index", type: :view do
  before(:each) do
    assign(:doctors, [
      Doctor.new({ name: "Doctor one", address: "Address one, City1, State1", image_url: "app/assets/images/doctor1.jpeg" }),
      Doctor.new({ name: "Doctor two", address: "Address two, City2, State2", image_url: "app/assets/images/doctor2.jpeg" })
    ])
  end

  # it "renders a list of doctors with doctor one" do
  #   render
  #   skip 'image_tag'
  #   expect(rendered).to match(/Doctor one/)
  # end
  #
  # it "renders a list of doctors with doctor two" do
  #   render
  #   expect(rendered).to match(/Doctor two/)
  # end
end
