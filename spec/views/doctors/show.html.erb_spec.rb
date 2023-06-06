require 'rails_helper'

RSpec.describe "doctors/show", type: :view do
  before(:each) do
    assign(:doctor, Doctor.create!(
      name: "Name",
      address: "MyText",
      image_url: "Image Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Image Url/)
  end
end
