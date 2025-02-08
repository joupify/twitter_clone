class Tweet < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 280 }

  after_create_commit { broadcast_prepend_to "tweets" }
end
