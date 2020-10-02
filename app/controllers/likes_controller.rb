class LikesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @like = current_user.likes.new(post_id: @post.id)
    @like.save
    @post.create_notification_like!(current_user)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @like = Like.find_by(post_id: @post.id, user_id: current_user.id).destroy
  end

end
