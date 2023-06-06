class User < ApplicationRecord
  attr_accessor :slot, :current_doctor, :cost
  has_many :appointments
  has_many :doctors, through: :appointments
end
