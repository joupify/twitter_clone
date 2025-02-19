class LikeMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tweet_mailer.tweet.subject
  #
  def new_like
    @tweet = params[:tweet]  # Le tweet qui a été liké
    @like = params[:like]    # L'objet "like" créé
    @user = params[:user]    # L'utilisateur qui a liké le tweet
  
    # Envoie l'email à l'auteur du tweet
    mail to: @tweet.user.email, subject: " #{@user.name} a liké votre tweet"
  end
  
end
