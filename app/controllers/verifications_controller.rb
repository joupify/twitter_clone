# app/controllers/verifications_controller.rb
class VerificationsController < ApplicationController
  before_action :authenticate_user!

  def create
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'eur',
          product_data: {
            name: 'Vérification de compte Twitter',
            description: 'Badge vérifié pour votre compte',
          },
          unit_amount: 500, # en centimes (5€)
        },
        quantity: 1,
      }],
      mode: 'payment',
      customer_email: current_user.email,
      success_url: verification_success_url,
      cancel_url: verifications_url
    )

    redirect_to session.url, allow_other_host: true
  end

  def success
    current_user.update(verified: true)
    redirect_to current_user, notice: "Félicitations ! Votre compte est vérifié ✅"
  end
end
