class UsersController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_user, except: :index

  def index
    @users = User.search(params[:search]).page(params[:page]).per(10)
  end

  def show
    @posts = @user.posts.order('updated_at DESC').limit(3)
  end

  def posts
    @posts = @user.posts.page(params[:page]).per(9)
  end

  def following
    @users = @user.following.page(params[:page]).per(10)
    render 'users/show_follow'
  end

  def followers
    @users = @user.followers.page(params[:page]).per(10)
    render 'users/show_follower'
  end

  def likes
    @posts = @user.liked_posts.page(params[:page]).per(9)
  end

  def comments
    @posts = @user.commented_posts.page(params[:page]).per(9)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
