# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  event_type :string
#  metadata   :json
#  status     :integer
#  string     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment_id :bigint
#  like_id    :bigint
#  tweet_id   :bigint
#  user_id    :bigint           not null
#
# Indexes
#
#  index_events_on_comment_id  (comment_id)
#  index_events_on_like_id     (like_id)
#  index_events_on_tweet_id    (tweet_id)
#  index_events_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (comment_id => comments.id)
#  fk_rails_...  (like_id => likes.id)
#  fk_rails_...  (tweet_id => tweets.id)
#  fk_rails_...  (user_id => users.id)
#
class Event < ApplicationRecord
  belongs_to :user
  belongs_to :tweet, optional: true  # Optional si l'événement ne concerne pas toujours un tweet
  belongs_to :like, optional: :true
  belongs_to :comment, optional: :true

  

validates :status, presence: true
validates :event_type, presence: true
enum :status, { pending: 0, completed: 1, failed: 2 }



  # Méthode pour marquer l'événement comme terminé
  def mark_as_completed
    update(status: 1)
  end

  # Méthode pour marquer l'événement comme échoué
  def mark_as_failed
    update(status: 2)
  end
end
