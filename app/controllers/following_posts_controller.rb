class FollowingPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_layout

  def index
    @posts = current_user.feed.search(params[:search]).page(params[:page]).per(16).order('updated_at DESC')
  end

  def novel
    @posts = current_user.feed.search(params[:search]).genre_novel.page(params[:page]).per(16).order('updated_at DESC')
  end

  def business
    @posts = current_user.feed.search(params[:search]).genre_business.page(params[:page]).per(16).order('updated_at DESC')
  end

  def education
    @posts = current_user.feed.search(params[:search]).genre_education.page(params[:page]).per(16).order('updated_at DESC')
  end

  def art_ent
    @posts = current_user.feed.search(params[:search]).genre_art_ent.page(params[:page]).per(16).order('updated_at DESC')
  end

  def celebrity
    @posts = current_user.feed.search(params[:search]).genre_celebrity.page(params[:page]).per(16).order('updated_at DESC')
  end

  def hobby
    @posts = current_user.feed.search(params[:search]).genre_hobby.page(params[:page]).per(16).order('updated_at DESC')
  end

  def geography
    @posts = current_user.feed.search(params[:search]).genre_geography.page(params[:page]).per(16).order('updated_at DESC')
  end

  def child
    @posts = current_user.feed.search(params[:search]).genre_child.page(params[:page]).per(16).order('updated_at DESC')
  end

  def others
    @posts = current_user.feed.search(params[:search]).genre_others.page(params[:page]).per(16).order('updated_at DESC')
  end

  private

   def set_layout
    @layout = 'following_posts'
    @current = 'following_posts'
   end
end
