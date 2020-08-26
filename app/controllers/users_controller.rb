class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: :show

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show

  end

  private

    def set_user
      @user = User.find(params[:id])
    end



end