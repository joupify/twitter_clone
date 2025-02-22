class EventJob < ApplicationJob
  queue_as :default

  def perform(event)
    begin
      return unless event # Vérifie que l'événement existe

      puts "Traitement de l'événement : #{event.event_type} pour l'utilisateur #{event.user.name}"

      # Ici, on effectue le traitement en fonction du type d'événement
      case event.event_type
      when 'tweet'
        tweet_notification_event(event)
        puts 'Un tweet a été créé !'
      when 'like'
        like_notification_event(event)
        puts 'Un tweet a été liké !'
      when 'comment'
        comment_notification_event(event)
        puts 'Un tweet a été commenté !'
      when 'new_follower'
        follower_notification_event(event)
        puts 'New abonné !'
      when 'new_mention'
        mention_notification_event(event)
        puts 'qq vous a mentionné !'
      else
        puts 'Événement inconnu.'
      end

      # Marquer l'événement comme terminé
      event.mark_as_completed
    rescue => e
      # En cas d'erreur, marquer l'événement comme échoué
      event.mark_as_failed
      Rails.logger.error "EventJob failed: #{e.message}"
      raise e # Relancer l'erreur pour que le job soit retenté si nécessaire
    end
  end

  private

  def tweet_notification_event(event)
    user = event.user
    tweet = event.tweet
    emails = user.follower_emails

    if emails.any? && user.followers.any?
      Rails
        .logger.info "Envoi d'emails à #{emails.size} followers pour le tweet #{tweet.id}"
      TweetNotifier
        .with(tweet: tweet, user: user, emails: emails)
        .deliver_later(user.followers)
    end
  end

  def like_notification_event(event)
    user = event.user
    tweet = event.tweet
    like = event.like

      LikeNotifier.with(tweet: tweet, user: user, like: like).deliver_later(user)
  end

  def comment_notification_event(event)
    user = event.user
    tweet = event.tweet
    comment = event.comment

      CommentNotifier.with(tweet: tweet, user: user, comment: comment).deliver_later(user)
  end


 
  def follower_notification_event(event)
    follower_id = event.metadata['follower_id']
    followed_id = event.metadata['followed_id']
  
    follower = User.find_by(id: follower_id)
    followed = User.find_by(id: followed_id)
  
    if follower && followed
      FollowerNotifier.with(follower: follower, followed: followed).deliver_later(followed)
    else
      Rails.logger.error("User not found for follower_id: #{follower_id} or followed_id: #{followed_id}")
    end
  end

  def mention_notification_event(event)
    user = event.user  # L'utilisateur mentionné
    tweet_id = event.metadata["tweet_id"]
    tweet = Tweet.find(tweet_id) # Utilisez l'ID du tweet des métadonnées
    
    mention_id = event.metadata["mention_id"]
    mention = Mention.find(mention_id) # Utilisez l'ID de la mention
    
    return unless user && tweet && mention  # Évite les erreurs si l'un des objets est nil
    
    MentionNotifier.with(tweet: tweet, user: user, mention: mention).deliver_later(user)
    
    puts "#{user.name}, vous avez été mentionné dans un tweet !"
  end
  
  

  


end