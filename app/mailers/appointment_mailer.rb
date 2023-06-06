class AppointmentMailer < ApplicationMailer
  def new_appointment_email
    @appointment = params[:appointment]
    mail(to: @appointment.user.email, subject: "Your Booking with MediApp in confirmed !!")
  end
end
