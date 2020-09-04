class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all.page(params[:page]).per(16)
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
    
  end

  def edit
  end

  def update
  end

  def destroy
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

end
