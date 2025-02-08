class TweetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tweets = Tweet.all.includes(:user, :likes).order(created_at: :desc)
    @tweet = Tweet.new
    @user_liked_tweet_ids = current_user&.liked_tweets&.pluck(:id) || []
  end

  def create
    @tweet = current_user.tweets.new(tweet_params)
    if @tweet.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("tweet_#{@tweet.id}", partial: 'tweets/tweet', locals: { tweet: @tweet, user_liked_tweet_ids: @user_liked_tweet_ids }),
          ]
        end
      end
    else
      render :index, status: :unprocessable_entity
    end
  end

  def like
    @tweet = Tweet.find(params[:id])
    if current_user.liked_tweets.include?(@tweet)
      redirect_to tweets_path, alert: "You have already liked this tweet."
    else
      current_user.likes.create(tweet: @tweet)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("tweet_#{@tweet.id}", partial: 'tweets/tweet', locals: { tweet: @tweet, user_liked_tweet_ids: @user_liked_tweet_ids }),
          ]
        end
      end
    end
  end

  def unlike
    @tweet = Tweet.find(params[:id])
    like = current_user.likes.find_by(tweet: @tweet)
    if like
      like.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("tweet_#{@tweet.id}", partial: 'tweets/tweet', locals: { tweet: @tweet, user_liked_tweet_ids: @user_liked_tweet_ids }),
          ]
        end
      end
    else
      redirect_to tweets_path, notice: "Tweet already unliked!"
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end
end
