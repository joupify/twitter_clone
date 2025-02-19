class CommentMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.comment_mailer.new_comment.subject
  #
  def new_comment
    @greeting = "Hi"
    @tweet = params[:tweet]  # Le tweet qui a été commenté
    @comment = params[:comment]
    @user = params[:user]    # L'utilisateur qui a commenté le tweet
  
    # Envoie l'email à l'auteur du tweet
    mail to: @tweet.user.email, subject: " #{@user.name} a commenté votre tweet"
  end
end
