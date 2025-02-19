# To deliver this notification:
#
# LikeNotifier.with(record: @post, message: "New post").deliver(User.all)

class LikeNotifier < ApplicationNotifier
  # Add your delivery methods
  #
   deliver_by :email do |config|
     config.mailer = "LikeMailer"
     config.method = "new_like"
  end
  #
  # bulk_deliver_by :slack do |config|
  #   config.url = -> { Rails.application.credentials.slack_webhook_url }
  # end
  #
  # deliver_by :custom do |config|
  #   config.class = "MyDeliveryMethod"
  # end

  # Add required params
  #
   required_param :like



  # URL vers laquelle rediriger l'utilisateur lorsqu'il clique sur la notification
  def url
    tweet_path(params[:tweet])
  end
end
