require 'net/http'
require 'json'

class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  EMAIL_WAIT_TIME = 2.hours

    # GET /users or /users.json
  def index
    @users = User.all
  end

  def get_exchange_rates
    url = URI.parse('https://api.apilayer.com/fixer/latest?base=INR&symbols=EUR,USD')
    req = Net::HTTP::Get.new(url)
    req['apikey'] = ENV.fetch("FIXER_API_KEY")
    res = Net::HTTP.start(url.hostname, url.port, use_ssl: url.scheme == 'https') { |http|
      http.request(req)
    }
    res.body
  end

  def update_currency
    file = File.open("exchange_rates.json", "a+")
    @exchange_rates = JSON.load(file) || {}
    if @exchange_rates.length == 0 || file.ctime.day != DateTime.now.day
      @exchange_rates = get_exchange_rates
      file.close
      file = File.open("exchange_rates.json", "w+")
      file.write(@exchange_rates.to_json)
      file.close
    end

    redirect_to new_user_path(:current_doctor => params[:current_doctor], :slot => params[:slot], :currency => params[:currency], :usd_exchange => JSON.parse(@exchange_rates)["rates"]["USD"], :eur_exchange => JSON.parse(@exchange_rates)["rates"]["EUR"])
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  def turbo_form
    render :new, status: :ok
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    make_payment
    @user = User.find_or_initialize_by(:email => user_params[:email])
    @user.assign_attributes(user_params)
    respond_to do |format|
      if @user.save
        start_time = params[:user][:slot].to_datetime
        end_time = start_time + 1.hour
        current_doctor = params[:user][:current_doctor].to_i
        cost = params[:user][:cost].to_i
        @appointment = Appointment.new(start_time: start_time.to_s, end_time: end_time, cost: cost, user: @user, doctor_id: current_doctor)
        @appointment.save

        AppointmentMailer.with(appointment: @appointment).new_appointment_email.deliver_later(wait_until: (end_time + EMAIL_WAIT_TIME).to_datetime.in_time_zone("Chennai"))
        format.html { redirect_to appointment_created_path(:appointment => @appointment.id), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :currency)
  end

  def make_payment
    sleep(1)
  end
end
