# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  banner                 :string
#  bio                    :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet
  has_many :retweets, class_name: 'Tweet', dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :commented_tweets, through: :comments, source: :tweet

  has_many :favorites, dependent: :destroy
  has_many :favorited_tweets, through: :favorites, source: :tweet
  has_many :notifications, class_name: 'Noticed::Notification', as: :recipient, dependent: :destroy


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



  def notify_user(action, object)
    tweet = case action
            when :like
              object.tweet
            when :comment
              object.tweet
            else
              object
            end

      # tweet = like.tweet  # Récupère le tweet associé au like
      # Créer un événement pour enregistrer cette action
      event = Event.create!(
        user: self,
        tweet: tweet,
        like: action == :like ? object : nil,
        comment: action == :comment ? object : nil,
        event_type: action.to_s,
        status: :pending,
      )

      # Lancer le job pour traiter l'événement
      EventJob.perform_later(event)
  end

  def notify_new_follower(followed)
    event = Event.create!(
      user: self,  # L'utilisateur qui est suivi
      event_type: 'new_follower',
      status: :pending,
      metadata: { follower_id: self.id, followed_id: followed.id }
      )
  
    EventJob.perform_later(event)
  end




end


