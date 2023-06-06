class DoctorsController < ApplicationController
  before_action :set_doctor, only: %i[ show edit update destroy ]

  # GET /doctors or /doctors.json

  def get_first_available_slot(current_doctor, slot)
    appointments = AppointmentsController.new
    appointments.request = request
    appointments.response = response
    slots = appointments.get_available_slots(current_doctor.id, slot)
    slots.values[0][0]
  end

  def index
    @doctors = Doctor.all
    @first_available_slot = {}
    @doctors.each do |doctor|
      @first_available_slot[doctor] = get_first_available_slot(doctor, nil)
    end
  end

  # GET /doctors/1 or /doctors/1.json
  def show
  end

  # GET /doctors/new
  def new
    @doctor = Doctor.new
  end

  # GET /doctors/1/edit
  def edit
  end

  # POST /doctors or /doctors.json
  def create
    @doctor = Doctor.new(doctor_params)

    respond_to do |format|
      if @doctor.save
        format.html { redirect_to doctor_url(@doctor), notice: "Doctor was successfully created." }
        format.json { render :show, status: :created, location: @doctor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doctors/1 or /doctors/1.json
  def update
    respond_to do |format|
      if @doctor.update(doctor_params)
        format.html { redirect_to doctor_url(@doctor), notice: "Doctor was successfully updated." }
        format.json { render :show, status: :ok, location: @doctor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /doctors/1 or /doctors/1.json
  def destroy
    @doctor.destroy

    respond_to do |format|
      format.html { redirect_to doctors_url, notice: "Doctor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctor
      @doctor = Doctor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def doctor_params
      params.require(:doctor).permit(:name, :address, :image_url, :clinic_start_time, :clinic_end_time, :lunch_start_time, :lunch_end_time)
    end
end
