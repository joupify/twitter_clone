class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet
  def index
  @tweets = Tweet.where(parent_id: nil).includes(:user, :likes).order(created_at: :desc)
    @tweet = Tweet.new
    @user_liked_tweet_ids = current_user&.liked_tweets&.pluck(:id) || []
  # @user_commented_tweet_ids = current_user&.commented_tweets&.pluck(:id) || []

  respond_to do |format|
    format.html # Rend la vue HTML par défaut (index.html.erb)
    format.turbo_stream # Rend la vue Turbo Stream par défaut (index.turbo_stream.erb)
  end
  end


  def show
    @tweet = Tweet.find_by(id: params[:id]) # Utilisez `find_by` pour éviter une exception si le tweet n'existe pas
    # increment_views  # Incrémente aussi les vues ici

    if @tweet.nil?
      redirect_to tweets_path, alert: 'Tweet non trouvé'
    end
  end


  def create
    @tweet = current_user.tweets.new(tweet_params)

    if @tweet.save
      flash.now[:notice] = 'Tweet created!'

    else
      flash.now[:notice] = @tweet.errors.full_messages.to_sentence
      render :index, status: :unprocessable_entity
    end
  end

  def retweet
    original_tweet = Tweet.find(params[:id])
    if current_user.retweets.exists?(parent_id: original_tweet.id)
       flash[:notice] = 'You have already retweeted this tweet.'
    elsif
      current_user.id == original_tweet.user_id
      flash[:notice] = 'You cannot retweet your own tweet.'
    else
    current_user.tweets.create(content: original_tweet.content, parent_id: original_tweet.id)
    flash[:notice] = 'ReTweet created!'

    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('flash', partial: 'layouts/flash')

        ]
      end
      format.html { redirect_to tweets_path }
    end
  end


  def like
    @tweet = Tweet.find(params[:id])
    if current_user.liked_tweets.include?(@tweet)
      flash[:notice] = 'You have already liked this tweet.'
    elsif current_user.id == @tweet.user_id
      flash[:notice] = 'You cannot like your own tweet.'
    else
      current_user.likes.create(tweet: @tweet)
      flash[:notice] = 'Tweet liked!'
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('flash', partial: 'layouts/flash'),
          turbo_stream.replace("tweet_#{@tweet.id}", partial: 'tweets/tweet', locals: { tweet: @tweet, user_liked_tweet_ids: current_user&.liked_tweets&.pluck(:id) || [] })
        ]
      end
      format.html { redirect_to tweets_path }
    end
  end

  def unlike
    @tweet = Tweet.find(params[:id])
    like = current_user.likes.find_by(tweet: @tweet)
    if like
      like.destroy
      flash[:notice] = 'Tweet unliked!'
    else
      flash[:alert] = 'Tweet already unliked!'
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('flash', partial: 'layouts/flash'),
          turbo_stream.replace("tweet_#{@tweet.id}", partial: 'tweets/tweet', locals: { tweet: @tweet, user_liked_tweet_ids: current_user&.liked_tweets&.pluck(:id) || [] })
        ]
      end
      format.html { redirect_to tweets_path }
    end
  end

  def increment_views
    @tweet = Tweet.find(params[:id])
    @tweet.increment!(:views_count) # Ajoute +1 à chaque affichage
    head :ok # Renvoie une réponse vide avec un statut 200 (OK)
  end

def favorite
  @tweet = Tweet.find(params[:id])
  if current_user.favorited_tweets.include?(@tweet)
    flash[:notice] = 'You have already favorited this tweet.'
  else
    current_user.favorites.create(tweet: @tweet)
    flash[:notice] = 'Tweet favorited!'
  end
  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: [
        turbo_stream.replace('flash', partial: 'layouts/flash'),
        turbo_stream.replace("tweet_#{params[:id]}", partial: 'tweets/tweet', locals: { tweet: @tweet })
      ]
    end
    format.html { redirect_to tweets_path }
  end
end

def unfavorite
  @tweet = Tweet.find(params[:id])
  favorite = current_user.favorites.find_by(tweet: @tweet)
  if favorite
    favorite.destroy
    flash[:notice] = 'Tweet unfavorited!'
  else
    flash[:alert] = 'Tweet already unfavorited!'
  end
  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: [
        turbo_stream.replace('flash', partial: 'layouts/flash'),
        turbo_stream.replace("tweet_#{params[:id]}", partial: 'tweets/tweet', locals: { tweet: @tweet })
      ]
    end
    format.html { redirect_to tweets_path }
  end
end


  private

  def set_tweet
    @tweet = Tweet.find_by(id: params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:content)
  end
end
