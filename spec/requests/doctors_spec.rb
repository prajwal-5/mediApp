require 'rails_helper'

RSpec.describe "/doctors", type: :request do

  let(:valid_attributes) {
    { name: "Doctor one", address: "Address one, City1, State1", image_url: "doctor1.jpeg"}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Doctor.create! valid_attributes
      get doctors_url
      expect(response).to be_successful
    end
  end
end
