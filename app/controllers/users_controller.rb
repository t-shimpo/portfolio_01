class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :following, :followers]
  before_action :set_user, only: [:show, :following, :followers]

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
  end

  def following
    @users = @user.following.page(params[:page]).per(10)
    render 'users/show_follow'
  end

  def followers
    @users = @user.followers.page(params[:page]).per(10)
    render 'users/show_follower'
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

end