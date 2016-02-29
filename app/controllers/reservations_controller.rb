class ReservationsController < ApplicationController
  before_action :authorize_edit, only: [:edit, :update]

  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      flash[:notice] = 'You have successfully responded with your RSVP.'
      ReservationMailer.send_confirmation_email(@reservation).deliver_now
      redirect_to root_path
    else
      flash.now[:warning] = @reservation.errors.messages.map{ |key, value|
        value.map { |error|
          key.to_s.titleize + ' ' + error
        }
      }.flatten
      render :new
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])
  end

  def update
    @reservation = Reservation.find(params[:id])
    if @reservation.update(reservation_params)
      flash[:notice] = 'You have successfully updated your RSVP.'
      redirect_to root_path
    else
      flash.now[:warning] = @reservation.errors.messages.map{ |key, value|
        value.map { |error|
          key.to_s.titleize + ' ' + error
        }
      }.flatten
      render :new
      render :edit
    end
  end

  private

  def reservation_params
    params[:reservation][:edit_key] = rand(0..100000000).to_s.hash
    params.require(:reservation).permit(:first_name, :last_name, :email, :attending, :comments, :edit_key)
  end

  def authorize_edit
    if params[:edit_key] != Reservation.find(params[:id]).edit_key
      flash[:warning] = ['You are not allowed to do that.']
      redirect_to root_path
    end
  end
end
