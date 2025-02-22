# To deliver this notification:
#
# FollowerNotifier.with(record: @post, message: "New post").deliver(User.all)

class FollowerNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  deliver_by :email do |config|
    config.mailer = 'FollowerMailer'
    config.method = 'new_follower'
  end
  #
  # bulk_deliver_by :slack do |config|
  #   config.url = -> { Rails.application.credentials.slack_webhook_url }
  # end
  #
  # Ajoutez les paramètres requis
  required_param :follower
  required_param :followed


  # Définissez la méthode pour créer le contenu de la notification
  def message
    {
      title: 'Nouvel abonné',
      body: "#{params[:follower].name} vous suit maintenant",
      url: Rails.application.routes.url_helpers.user_path(params[:follower])
    }
  end
end
