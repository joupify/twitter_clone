class FollowerMailer < ApplicationMailer
  def new_follower
    @greeting = "Hi"
    @follower = params[:follower]  # L'utilisateur qui a suivi
    @followed = params[:followed]  # L'utilisateur qui est suivi

    mail to: @followed.email, subject: "#{@follower.name} vous suit maintenant"
  end
end
