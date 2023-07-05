class FakeServiceJob < ApplicationJob
  queue_as :default
  include Turbo::StreamsHelper
  include ActionView::RecordIdentifier
  MIN_IN_HOUR = 60
  SEC_IN_MIN = 60
  HOURS_IN_DAY = 24
  LEAST_DOUBLE_DIGIT = 10

  def perform(appointment)
    # render turbo_stream: turbo_stream.update('book_appointment', html: 'appointments/appointment_created', locals: { appointment: appointment })
    # Turbo::StreamsChannel.broadcast_render_from('aid', partial: 'appointment_created.html.erb', locals: {appointment: appointment})
    Turbo::StreamsChannel.broadcast_update_to("inbox_list", target: "payment_loader", partial: 'appointments/appointment_created', locals: get_locals(appointment))
  end

  private
  def get_locals(appointment)
    time = appointment.start_time
    current_user = User.find(appointment.user_id)
    time_difference = time - Time.now

    min_difference, sec_difference = time_difference.divmod(MIN_IN_HOUR)
    hours_difference, min_difference = min_difference.divmod(SEC_IN_MIN)
    days_difference, hours_difference = hours_difference.divmod(HOURS_IN_DAY)

    days_difference = days_difference.to_s.rjust(2, '0')
    hours_difference = hours_difference.to_s.rjust(2, '0')
    min_difference = min_difference.to_s.rjust(2, '0')
    sec_difference = sec_difference.to_i.to_s.rjust(2, '0')
    {
      time: time,
      current_user: current_user,
      days_difference: days_difference,
      hours_difference: hours_difference,
      min_difference: min_difference,
      sec_difference: sec_difference
    }
  end
end
