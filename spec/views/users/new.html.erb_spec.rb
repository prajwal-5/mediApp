require 'rails_helper'

RSpec.describe "users/new", type: :view do
  let(:user) { User.new }

  before(:each) do
    assign(:user, user)
  end

  it "should have a form" do
    render
    expect(rendered).to match(/input/)
  end
end
