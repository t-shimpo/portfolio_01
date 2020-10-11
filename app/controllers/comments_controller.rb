class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      @post.create_notification_comment!(current_user, @comment.id)
      render :index
    else
      render :error
    end
  end

  def edit; end

  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update!(comment_update_params)
    render json: @comment
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

  def comment_update_params
    params.require(:comment).permit(:comment_content)
  end
end
