class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet


  def new
    @comment = @tweet.comments.build # Cela crée une instance unique de Comment
  end

  def show
    @comment = Comment.find(params[:id])
  end




  def create
    @tweet = Tweet.find(params[:tweet_id])
    @comment = @tweet.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:notice] = 'Comment was successfully created.'
      redirect_to tweet_path(@tweet) # Ajoutez une redirection après la création
    else
      flash[:alert] = @comment.errors.full_messages.to_sentence
      redirect_to tweet_path(@tweet) # Redirigez vers la page du tweet en cas d'erreur
    end
  end


  def destroy
    @tweet = Tweet.find(params[:tweet_id])
    @comment = @tweet.comments.find(params[:id])
    @comment.destroy
    redirect_to tweet_path(@tweet)
  end


private
def set_tweet
  @tweet = Tweet.find(params[:tweet_id])
end

def comment_params
  params.require(:comment).permit(:content)
end
end
