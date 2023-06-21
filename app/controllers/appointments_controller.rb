class AppointmentsController < ApplicationController
  # before_action :set_appointment, only: %i[ show edit update destroy ]
  MIN_IN_HOUR = 60
  SEC_IN_MIN = 60
  HOURS_IN_DAY = 24
  LEAST_DOUBLE_DIGIT = 10
  # GET /appointments or /appointments.json
  def index
    @current_doctor = Doctor.find(params[:current_doctor])
    @previous_appointments = Appointment.select(:start_time).where(doctor_id: @current_doctor.id).flat_map(&:start_time).map(&:to_datetime)
    @available_appointment_slots = Appointment.get_available_slots(@current_doctor)
    @chosen_slot = params[:slot]
  end

  def update_slot
    @current_doctor = Doctor.find(params[:current_doctor])
    redirect_to appointments_url(:current_doctor => params[:current_doctor], :slot => params[:slot], :day => params[:day])
  end

  # GET /appointments/1 or /appointments/1.json
  def show
    if request.method == "POST" || session[:current_user].present?
      current_user = session[:current_user]
      if request.method == "POST"
        user = User.find_by_email(params[:inputEmail])
      else
        user = User.find(current_user["id"])
      end
      @appointments = user.present? ? user.appointments : []
      session[:current_user] = user
      @allowed_cancel_time = 30.minutes
      respond_to do |format|
        format.html { render :template => "appointments/show" }
      end
    else
      respond_to do |format|
        format.html { render :template => "appointments/get_email" }
      end
    end
  end

  def appointment_created
    appointment = Appointment.find(params[:appointment])
    @time = appointment.start_time
    @current_user = User.find(appointment.user_id)
    time_difference = @time - Time.now

    @min_difference, @sec_difference = time_difference.divmod(MIN_IN_HOUR)
    @hours_difference, @min_difference = @min_difference.divmod(SEC_IN_MIN)
    @days_difference, @hours_difference = @hours_difference.divmod(HOURS_IN_DAY)

    @days_difference = @days_difference.to_s.rjust(2, '0')
    @hours_difference = @hours_difference.to_s.rjust(2, '0')
    @min_difference = @min_difference.to_s.rjust(2, '0')
    @sec_difference = @sec_difference.to_i.to_s.rjust(2, '0')

    respond_to do |format|
      format.html { render :template => "appointments/appointment_created" }
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    @appointment = Appointment.find(params[:id])
    user = @appointment.user
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to show_path(:user => user), notice: "Appointment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def csv_invoice
    appointment = Appointment.find(params[:appointment])
    headers = ['name', 'email', 'doctor', 'start_time', 'end_time', 'cost']

    csv_data = CSV.generate(headers: true) do |csv|
      csv << headers
      csv << [appointment.user.name, appointment.user.email, appointment.doctor.name, appointment.start_time, appointment.end_time, appointment.cost.to_s + " " + appointment.user.currency]
    end

    file = File.open("invoice.csv", "w+")
    file.write(csv_data)
    file.close
    send_file 'invoice.csv', :type => "application/csv", :x_sendfile => true
  end

  def txt_invoice
    appointment = Appointment.find(params[:appointment])
    txt_data = get_text_data(appointment)
    file = File.open("invoice.txt", "w+")
    file.write(txt_data)
    file.close
    send_file 'invoice.txt', :type => "application/txt", :x_sendfile => true
  end

  def pdf_invoice
    appointment = Appointment.find(params[:appointment])
    Prawn::Document.generate("invoice.pdf") do |pdf|
      pdf.text get_text_data(appointment)
    end
    send_file 'invoice.pdf', :type => "application/pdf", :x_sendfile => true
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(:start_time, :end_time, :doctor_id, :cost, :user_id)
  end

  def get_text_data(appointment)
    "
    Name: #{appointment.user.name} \n
    Email: #{appointment.user.email} \n
    Doctor's Name: #{appointment.doctor.name} \n
    Doctor's Address: #{appointment.doctor.address} \n
    Appointment Date: #{appointment.start_time.strftime("%a, %dth %B")} \n
    Appointment Start Time: #{appointment.start_time.strftime("%I:%M %p")} \n
    Appointment Cost: #{appointment.cost} #{appointment.user.currency} \n
    "
  end
end
