require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    @current_user = User.new({name: "Test Subject", email: "19BCS1010test@gmail.com", currency: "INR"})
  end

  describe "User" do
    it 'should not accept invalid name of user' do
      @current_user.name = "!nv@lid n@ame"
      expect(@current_user.save).to be_falsey
    end

    it 'should not accept invalid email address' do
      @current_user.email = "19bcstestemail.com"
      expect(@current_user.save).to be_falsey
    end

    it 'should accept user if name is present' do
      @current_user.name = nil
      expect(@current_user.save).to be_falsey
    end

    it 'should accept user if email is present' do
      @current_user.email = nil
      expect(@current_user.save).to be_falsey
    end
  end
end
