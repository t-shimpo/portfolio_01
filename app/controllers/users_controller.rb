class UsersController < ApplicationController
  before_action :authenticate_user!, only: :show
  before_action :set_user, only: :show

  def index

  end

  def show


  end

  private

  # def user_params
  #   params.require(:user).permit(:nickname, :email, :password)
  # end

  def set_user
    @user = User.find(params[:id])
  end



end