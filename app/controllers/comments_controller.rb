class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    render :index
  end

  def edit
  end

  def update
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy
    render :index
  end

  private

  def comment_params
    params.require(:comment).permit(:comment_content, :post_id, :user_id)
  end



  # def create
  #   # @post = Post.find(params[:post_id])
  #   # @comments = @post.comments
  #   @comment = current_user.comments.build(comment_params)
  #   if @comment.save
  #     flash[:notice] = "コメントが登録されました。"
  #     redirect_back(fallback_location: root_path)
  #   else
  #     flash[:alert] = "コメントは登録されませんでした。"
  #     redirect_back(fallback_location: root_path)
  #     # render 'posts/show'
  #   end
  # end

  # private
  #   def comment_params
  #     params.require(:comment).permit(:comment_content, :post_id)
  #   end

end
