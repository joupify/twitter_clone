class TweetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tweets = Tweet.all.includes(:user, :likes).order(created_at: :desc)
    @tweet = Tweet.new
    @user_liked_tweet_ids = current_user&.liked_tweets&.pluck(:id) || []


  respond_to do |format|
    format.html # Rend la vue HTML par défaut (index.html.erb)
    format.turbo_stream do
      # Vous pouvez ajouter des mises à jour Turbo ici si nécessaire
      # Par exemple, pour mettre à jour les messages flash :
      render turbo_stream: [
        turbo_stream.update('flash', partial: 'shared/flashes', locals: { notice: flash[:notice] })
      ]
    end
  end
  end

  def create
    @tweet = current_user.tweets.new(tweet_params)

    if @tweet.save
      flash.now[:notice] = 'Tweet created!'
      Turbo::StreamsChannel.broadcast_replace_to(
        'flash',
        target: 'flash',
        partial: 'shared/flashes'
      )
      head :ok
    else
      flash.now[:alert] = @tweet.errors.full_messages.to_sentence
      render :index, status: :unprocessable_entity
    end
  end

  def like
    @tweet = Tweet.find(params[:id])

    if current_user.liked_tweets.include?(@tweet)
      flash.now[:notice] = 'You have already liked this tweet.'
    elsif current_user.id == @tweet.user_id
      flash.now[:notice] = 'You cannot like your own tweet.'
    else
      current_user.likes.create(tweet: @tweet)
      flash.now[:notice] = 'Tweet liked!'
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('flash', partial: 'shared/flashes', locals: { notice: 'Tweet liked.' }),
          turbo_stream.replace("tweet_#{@tweet.id}", partial: 'tweets/tweet', locals: { tweet: @tweet })
        ]
      end
      format.html { redirect_to tweets_path, notice: 'Tweet liked.' }
    end
  end


  def unlike
    @tweet = Tweet.find(params[:id])
    like = current_user.likes.find_by(tweet: @tweet)

    if like
      like.destroy
      flash.now[:notice] = 'Tweet unliked!'
    else
      flash.now[:alert] = 'Tweet already unliked!'
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('flash', partial: 'shared/flashes', locals: { notice: 'Tweet liked.' }),
          turbo_stream.replace("tweet_#{@tweet.id}", partial: 'tweets/tweet', locals: { tweet: @tweet })
        ]
      end
      format.html { redirect_to tweets_path, notice: 'Tweet liked.' }
    end
  end

  private




  def tweet_params
    params.require(:tweet).permit(:content)
  end
end
