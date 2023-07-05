class DoctorsController < ApplicationController
  before_action :set_doctor, only: %i[ show edit update destroy ]

  # GET /doctors or /doctors.json
  def index
    @doctors = Doctor.all
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
