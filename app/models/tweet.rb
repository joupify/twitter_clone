class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  validates :content, presence: true, length: { maximum: 280 }

  after_create_commit { broadcast_prepend_to 'tweets' }
end
