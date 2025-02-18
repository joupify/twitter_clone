# To deliver this notification:
#
# TweetNotifier.with(record: @post, message: "New post").deliver(User.all)

class TweetNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  deliver_by :email do |config|
     config.mailer = 'TweetMailer'
     config.method = 'new_tweet'
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
   required_param :tweet


   def message
    "Un nouvel tweet a été posté par #{params[:tweet].user.name} : #{params[:tweet].content.truncate(50)}"
  end

  # URL vers laquelle rediriger l'utilisateur lorsqu'il clique sur la notification
  def url
    tweet_path(params[:tweet])
  end



  # Ajoutez une méthode pour personnaliser les destinataires
  def recipients
    params[:emails].map do |email|
      { email: email }
    end
  end
end
