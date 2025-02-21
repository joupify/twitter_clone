class MentionMailer < ApplicationMailer
  def new_mention
    @tweet = params[:tweet]  # Le tweet contenant la mention
    @mention = params[:mention]  # L'objet "mention" créé
    @user = params[:user]  # L'utilisateur qui a écrit le tweet (mentionneur)
    @mentioned_user = @mention.user  # L'utilisateur qui est mentionné

    mail to: @mentioned_user.email, subject: "#{@user.username} vous a mentionné dans un tweet"
  end
end
