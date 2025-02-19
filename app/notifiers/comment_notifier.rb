# To deliver this notification:
#
# CommentNotifier.with(record: @post, message: "New post").deliver(User.all)

class CommentNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  deliver_by :email do |config|
    config.mailer = "CommentMailer"
    config.method = "new_comment"
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
   required_param :comment


  # URL vers laquelle rediriger l'utilisateur lorsqu'il clique sur la notification
  def url
    tweet_path(params[:tweet])
  end

end
