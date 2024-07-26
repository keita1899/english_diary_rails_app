class UsersController < ApplicationController
  before_action :redirect_authenticated_user!, only: %i[new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      redirect_to diaries_url, notice: '新規登録が完了しました'
    else
      flash.now[:alert] = '新規登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
