class User < ApplicationRecord
  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet
  has_many :retweets, class_name: 'Tweet', dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :commented_tweets, through: :comments, source: :tweet
  has_many :notifications, class_name: 'Noticed::Notification', as: :recipient, dependent: :destroy


  has_many :favorites, dependent: :destroy
  has_many :favorited_tweets, through: :favorites, source: :tweet

  has_one_attached :avatar
  has_one_attached :banner

  validates :name, presence: true
  validates :avatar, presence: true

  # Un utilisateur peut suivre plusieurs autres utilisateurs (Followings)
  has_many :active_follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  has_many :followings, through: :active_follows, source: :followed

  # Un utilisateur peut être suivi par plusieurs utilisateurs (Followers)
  has_many :passive_follows, class_name: 'Follow', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    def following?(user)
      followings.include?(user)
    end


    def favorited?(tweet)
    favorited_tweets.include?(tweet)
    end

  def unread_notifications
    notifications.where(read_at: nil)
  end

  # Récupérer les e-mails des followers
  def follower_emails
    followers.pluck(:email)
  end

  def notify_followers(tweet)
    emails = follower_emails
    if emails.any?
      # Créer un événement pour enregistrer cette action
      event = Event.create!(
        user: self,
        tweet: tweet,
        event_type: 'tweet',
        status: :pending,
        metadata: { emails: emails }
      )

      # Lancer le job pour traiter l'événement
      EventJob.perform_later(event)
    end
  end


  # def notify_followers(tweet)
  #   # Récupérer les emails des followers
  #   emails = follower_emails
  #   if emails.any?
  #     emails.each do |email|
  #       user = User.find_by(email: email)
  #       if user
  #         # Enqueue le job pour chaque follower, pour l'événement 'tweet'
  #         JobEventJob.perform_later('tweet', user, tweet)
  #       end
  #     end
  #   end
  # end

  # def notify_followers(tweet)
  #   # Envoyer une notification par e-mail à tous les followers
  #   emails = follower_emails
  #   if follower_emails.any?
  #   TweetNotifier.with(tweet: tweet, user: self, emails: emails).deliver_later(followers)
  #   end
  # end
end
