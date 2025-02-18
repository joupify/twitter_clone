# Preview all emails at http://localhost:3000/rails/mailers/tweet_mailer
class TweetMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/tweet_mailer/tweet
  def tweet
    TweetMailer.tweet
  end
end
