class User < ApplicationRecord
  validates :name, :email, presence: true
  validates_format_of :email, :with => URI::MailTo::EMAIL_REGEXP
  validates_format_of :name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/
  attr_accessor :slot, :current_doctor, :cost
  has_many :appointments
  has_many :doctors, through: :appointments
end
