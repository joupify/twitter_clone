# == Schema Information
#
# Table name: messages
#
#  id          :bigint           not null, primary key
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  parent_id   :bigint
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

  belongs_to :parent, class_name: 'Message', optional: true
  has_many :replies, class_name: 'Message', foreign_key: 'parent_id', dependent: :destroy

  validates :content, presence: true
  validate :sender_and_receiver_are_different

  # Scope pour obtenir les messages envoyés ou reçus par un utilisateur
  scope :for_user, ->(user) { where("sender_id = ? OR receiver_id = ?", user.id, user.id) }


  # Scope pour précharger les réponses et leurs expéditeurs
  scope :with_replies, -> { includes(replies: [:sender]) }

  # Récupère les messages racines (sans parent)
  scope :roots, -> { where(parent_id: nil) }

  after_create_commit :broadcast_message
  after_update_commit :broadcast_message

  # Méthode récursive pour construire l'arborescence
  def self.build_tree(messages = roots)
    messages.includes(:sender, :receiver, replies: [:sender, :receiver]).map do |message|
      {
        message: message,
        replies: build_tree(message.replies)
      }
    end
  end


  private



  def broadcast_message
    stream_name = "messages_#{receiver_id}"
  
    if parent_id.present?
      puts "Broadcasting reply to: replies_to_#{parent_id}" # Log pour debug
      broadcast_append_to(
        stream_name,
        target: "replies_to_#{parent_id}",
        partial: "messages/message",
        locals: { message: self }
      )
    else
      puts "Broadcasting main message to: messages-container" # Log pour debug
      broadcast_append_to(
        stream_name,
        target: "messages-container",
        partial: "messages/message",
        locals: { message: self }
      )
    end
  end
  

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
