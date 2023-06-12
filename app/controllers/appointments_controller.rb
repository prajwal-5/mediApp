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
    if params[:user] || request.method == "POST"
      current_user = params[:user]
      if current_user.nil?
        @appointments = Appointment.joins(:user).where(:users => { :email => params[:inputEmail] })
      else
        @appointments = Appointment.joins(:user).where(:users => { :id => current_user })
      end
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
    @time = Time.parse(appointment.start_time.to_s)
    @current_user = User.find(appointment.user_id)
    time_difference = @time - Time.now

    @min_difference, @sec_difference = time_difference.divmod(MIN_IN_HOUR)
    @hours_difference, @min_difference = @min_difference.divmod(SEC_IN_MIN)
    @days_difference, @hours_difference = @hours_difference.divmod(HOURS_IN_DAY)

    if @days_difference < LEAST_DOUBLE_DIGIT
      @days_difference = "0" + @days_difference.to_s
    end

    if @hours_difference < LEAST_DOUBLE_DIGIT
      @hours_difference = "0" + @hours_difference.to_s
    end

    if @min_difference < LEAST_DOUBLE_DIGIT
      @min_difference = "0" + @min_difference.to_s
    end

    if @sec_difference < LEAST_DOUBLE_DIGIT
      @sec_difference = "0" + @sec_difference.to_s
    end
    respond_to do |format|
      format.html { render :template => "appointments/appointment_created" }
    end
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to appointment_created_path, notice: "Appointment was successfully created." }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to appointment_url(@appointment), notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
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
