# == Schema Information
#
# Table name: tweets
#
#  id              :bigint           not null, primary key
#  comments_count  :integer          default(0), not null
#  content         :text
#  favorites_count :integer          default(0), not null
#  likes_count     :integer          default(0), not null
#  retweets_count  :integer          default(0), not null
#  views_count     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_id       :integer
#  user_id         :bigint           not null
#
# Indexes
#
#  index_tweets_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  # Un tweet peut être un retweet d'un autre tweet
  belongs_to :parent, class_name: 'Tweet', optional: true, counter_cache: :retweets_count
  # Un tweet peut avoir plusieurs retweets (tweets avec un parent_id)
  has_many :retweets, class_name: 'Tweet', foreign_key: 'parent_id', dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :tweet

  scope :originals, -> { where(parent_id: nil) } # Pour filtrer les tweets non retweetés


  validates :content, presence: true, length: { maximum: 280 }

  after_create_commit { broadcast_prepend_to 'tweets' }
  after_initialize :set_defaults

  has_many :mentions, dependent: :destroy
  after_save :extract_mentions


  def retweets?(user)
    retweets.exists?(user_id: user.id)
  end

  private


  # Notifier les followers d'un nouveau tweet
  def notify_user_followers
    user.followers.each do |follower|
      follower.notify_user(:tweet, self)
    end
  end


  def set_defaults
    self.views_count ||= 0
  end

  def extract_mentions
  # Recherche tous les @username dans le texte du tweet
  mentioned_usernames = self.content.scan(/@(\w+)/).flatten

  mentioned_usernames.each do |username|
    user = User.find_by(username: username)
    if user && !mentions.exists?(user: user)  # Vérifier si la mention existe déjà
      mentions.create(user: user)
      mention = mentions.create(user: user) # Crée la mention et la stocke dans une variable
      user.notify_new_mention(self, mention) # Passe le tweet ET la mention à la méthode
    end
  end
  end
end
