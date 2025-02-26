# == Schema Information
#
# Table name: messages
#
#  id          :bigint           not null, primary key
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :bigint
#  sender_id   :bigint
#
# Indexes
#
#  index_messages_on_receiver_id  (receiver_id)
#  index_messages_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :content, presence: true
  validates :content, presence: true
  validate :sender_and_receiver_are_different

  private

  def sender_and_receiver_are_different
    if sender_id == receiver_id
      errors.add(:receiver_id, "Vous ne pouvez pas vous envoyer un message à vous-même.")
    end
  end

  # after_create :notify_receiver


  def notify_receiver
    receiver.notify_user(:message, self)
  end
end
