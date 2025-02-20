class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :follow, :unfollow ]
  before_action :authenticate_user!

  def show
    @tweets = @user.tweets.order(created_at: :desc)
    @liked_tweets = @user.liked_tweets
    @commented_tweets = @user.commented_tweets
    @followers = @user.followers
    @followings = @user.followings
  end

  def edit
    redirect_to user_path(@user), alert: 'Not authorized' unless current_user == @user
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path(@user), notice: 'Profile Successfully updated user'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Le current_user est l'utilisateur qui suit un autre utilisateur.
  # @user est l'utilisateur que current_user veut suivre.

  def follow
    unless current_user.following?(@user)
      current_user.followings << @user
    end
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @user, notice: "Vous suivez désormais #{@user.name}." }
    end
  end

  def unfollow
    current_user.followings.delete(@user)
    redirect_to @user, notice: "Vous ne suivez plus #{@user.name}."
  end



  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :username, :bio, :avatar)
  end
end
