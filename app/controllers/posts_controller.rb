class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_post, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all.page(params[:page]).per(16).order('updated_at DESC')
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "投稿されました。"
      redirect_to new_post_path
    else
      render 'posts/new'
    end
  end

  def new
    @post = Post.new
  end

  def show
    @comment = Comment.new
    @comments = @post.comments
  end

  def edit
  end

  def update
    if @post.update_attributes(post_params)
      flash[:notice] = "投稿は更新されました。"
      redirect_to @post
    else
      render 'posts/edit'
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "投稿は削除されました。"
    redirect_to @post.user
  end


  private

    def post_params
     params.require(:post).permit(
       :post_image,
       :title,
       :author,
       :publisher,
       :genre,
       :rating,
       :hours,
       :purchase_date,
       :post_content
     ).merge(user_id: current_user.id)
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to posts_url if @post.nil?
    end

end
