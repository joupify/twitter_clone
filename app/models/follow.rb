class Follow < ApplicationRecord
belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'
belongs_to :followed, class_name: 'User', foreign_key: 'followed_id'


validates :follower_id, uniqueness: { scope: :followed_id }
validate :cannot_follow_self


private

def cannot_follow_self
  errors.add(:follower, "Vous ne pouvez pas vous suivre vous-même") if follower == followed
end


end
