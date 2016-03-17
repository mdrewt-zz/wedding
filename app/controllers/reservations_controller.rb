class ReservationsController < ApplicationController
  before_action :authorize_edit, only: [:edit, :update]
  before_action :map_guest_attributes, only: [:create, :update]
  before_action :generate_edit_key, only: [:create]
  before_filter :authorize, only: [:index]

  def index
    @reservations = Reservation.all
  end

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
    render :new
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
    end
  end

  private

  def map_guest_attributes
    if params[:reservation] && params[:reservation][:guests_attributes]
      params[:reservation][:guests_attributes].each_key { |key|
        new_value = params[:reservation][:guests_attributes][key]
        new_value = JSON.parse(new_value) if new_value.class == String
        new_value['_destroy'] = JSON.parse(new_value['attributes'])['_destroy'] if new_value['attributes']
        params[:reservation][:guests_attributes][key] = new_value
      }
    end
  end

  def generate_edit_key
    params[:reservation][:edit_key] = rand(0..100000000).to_s.hash
  end

  def reservation_params
    params.require(:reservation).permit(:first_name, :last_name, :email, :attending, :comments, :edit_key, guests_attributes: [:first_name, :last_name, :email, :_destroy, :id])
  end

  def authorize_edit
    params[:edit_key] ||= params[]
    if params[:edit_key] != Reservation.find(params[:id]).edit_key
      flash[:warning] = ['You are not allowed to do that.']
      redirect_to root_path
    end
  end
end
