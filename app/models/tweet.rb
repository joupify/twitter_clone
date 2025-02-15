class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  belongs_to :parent, class_name: 'Tweet', optional: true
  has_many :retweets, class_name: 'Tweet', foreign_key: 'parent_id', dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :tweet

  scope :originals, -> { where(parent_id: nil) } # Pour filtrer les tweets non retweetés


  validates :content, presence: true, length: { maximum: 280 }

  after_create_commit { broadcast_prepend_to 'tweets' }

  after_initialize :set_defaults



  def retweets?(user)
    retweets.exists?(user_id: user.id)
  end

  private

  def set_defaults
    self.views_count ||= 0
  end
end
