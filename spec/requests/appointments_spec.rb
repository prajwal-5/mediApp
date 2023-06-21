require 'rails_helper'

RSpec.describe "/appointments", type: :request do

  before :all do
    @doctor = Doctor.new({ name: "Doctor one", address: "Address one, City1, State1", image_url: "doctor1.jpeg" })
    @user = User.new({name: "Prajwal", email: "19bcstest@cuchd.in", currency: "INR"})
    @slot = Appointment.get_available_slots(@doctor).first.first

    @valid_attributes = {
      :name => "Prajwal",
      :email => "19bcs1010@testcuchd.in",
      :currency => "INR",
      :slot => @slot,
      :current_doctor => Doctor.first.id,
      :cost => 500
    }

    @invalid_attributes = {
      :name => "Pr@jwal",
      :email => "19bcs1010testcuchd.in",
      :currency => "INR",
      :slot => @slot,
      :current_doctor => Doctor.first.id,
      :cost => 500
    }
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Appointment" do
        expect {
          post users_url, params: { user: @valid_attributes }
        }.to change(Appointment, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Appointment" do
        expect {
          post users_url, params: { user: @invalid_attributes }
        }.to change(Appointment, :count).by(0)
      end
    end
  end
end
