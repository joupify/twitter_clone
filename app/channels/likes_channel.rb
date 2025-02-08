class LikesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'likes'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
