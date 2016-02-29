class ReservationMailer < ApplicationMailer
  def send_confirmation_email(reservation)
    @reservation = reservation
    mail(to: @reservation.email, subject: 'Thank you for RSVPing!', template_path: 'reservation_mailer', template_name: 'reservation_confirmation')
  end
end
