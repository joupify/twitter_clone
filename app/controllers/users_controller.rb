class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authenticate_user!

  def show
    @tweets = @user.tweets.order(created_at: :desc)
    @liked_tweets = @user.liked_tweets 
    @commented_tweets = @user.commented_tweets 
  end

  def edit
    redirect_to user_path(@user), alert: "Not authorized" unless current_user == @user
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path(@user), notice: "Profile Successfully updated user"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :bio, :avatar)
  end
end
