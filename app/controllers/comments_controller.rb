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
    @depth = @comment.parent_id ? params[:depth].to_i + 1 : 0
    

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @tweet, notice: "Commentaire ajouté !" }
      end
    else
      respond_to do |format|
        format.html { render 'tweets/show', status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @tweet = Tweet.find(params[:tweet_id])
    @comment = @tweet.comments.find(params[:id])
    @comment.destroy
    redirect_to tweet_path(@tweet)
  end

# app/controllers/comments_controller.rb
# app/controllers/comments_controller.rb
def create_reply
  @comment = Comment.find(params[:id])
  @reply = @comment.replies.create(comment_params)
  @reply.user = current_user

  respond_to do |format|
    format.turbo_stream { render turbo_stream: turbo_stream.append("replies-#{@comment.id}", partial: "comments/comment", locals: { comment: @reply, depth: 1 }) }
    format.html { redirect_to tweet_path(@comment.tweet) }
  end
end



private
def set_tweet
  @tweet = Tweet.find(params[:tweet_id])
end

def comment_params
  params.require(:comment).permit(:content, :parent_id)
end
end
