# Preview all emails at http://localhost:3000/rails/mailers/follower_mailer
class FollowerMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/follower_mailer/new_follower
  def new_follower
    FollowerMailer.new_follower
  end
end
