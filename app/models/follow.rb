# == Schema Information
#
# Table name: follows
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :bigint           not null
#  follower_id :bigint           not null
#
# Indexes
#
#  index_follows_on_followed_id                  (followed_id)
#  index_follows_on_follower_id                  (follower_id)
#  index_follows_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (followed_id => users.id)
#  fk_rails_...  (follower_id => users.id)
#
class Follow < ApplicationRecord
belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'
belongs_to :followed, class_name: 'User', foreign_key: 'followed_id'


validates :follower_id, uniqueness: { scope: :followed_id }
validate :cannot_follow_self


private

def cannot_follow_self
  errors.add(:follower, 'Vous ne pouvez pas vous suivre vous-même') if follower == followed
end
end
