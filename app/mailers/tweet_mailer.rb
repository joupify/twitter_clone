class TweetMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tweet_mailer.tweet.subject
  #
  def new_tweet
    @tweet = params[:tweet]
    @user = params[:user]
    @greeting = 'Hi'


    # Envoyer l'e-mail à tous les followers
    mail to: params[:emails], subject: "Un nouvel tweet a été posté par #{@tweet.user.name} : #{@tweet.content.truncate(50)}"
  end
end
