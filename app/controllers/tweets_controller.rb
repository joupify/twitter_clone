class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all.order(created_at: :desc)
    @tweet = Tweet.new
  end

  def create
    @tweet = current_user.tweets.new(tweet_params)
    if @tweet.save
      respond_to do |format|
        format.html { redirect_to tweets_path, notice: "Tweet publié avec succès." }
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend('tweets', partial: 'tweets/tweet', locals: { tweet: @tweet })
        end
      end
    else
      render :index, status: :unprocessable_entity
    end
  end


  def tweet_params
    params.require(:tweet).permit(:content)
  end
end
