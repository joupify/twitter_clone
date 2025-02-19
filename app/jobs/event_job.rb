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
end