class TweetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tweets = Tweet.all.includes(:user, :likes).order(created_at: :desc)
    @tweet = Tweet.new
    @user_liked_tweet_ids = current_user&.liked_tweets&.pluck(:id) || []


  respond_to do |format|
    format.html # Rend la vue HTML par défaut (index.html.erb)
    format.turbo_stream # Rend la vue Turbo Stream par défaut (index.turbo_stream.erb)
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
       flash[:notice] = "You have already retweeted this tweet."
    elsif
      current_user.id == original_tweet.user_id
      flash[:notice] = "You cannot retweet your own tweet."    
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
  


  private




  def tweet_params
    params.require(:tweet).permit(:content)
  end
end
