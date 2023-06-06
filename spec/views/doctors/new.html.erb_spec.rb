require 'rails_helper'

RSpec.describe "doctors/new", type: :view do
  before(:each) do
    assign(:doctor, Doctor.new(
      name: "MyString",
      address: "MyText",
      image_url: "MyString"
    ))
  end

  it "renders new doctor form" do
    render

    assert_select "form[action=?][method=?]", doctors_path, "post" do

      assert_select "input[name=?]", "doctor[name]"

      assert_select "textarea[name=?]", "doctor[address]"

      assert_select "input[name=?]", "doctor[image_url]"
    end
  end
end
