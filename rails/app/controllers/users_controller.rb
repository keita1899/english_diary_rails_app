class UsersController < ApplicationController
  before_action :redirect_authenticated_user!, only: %i[new]
  before_action :require_login, only: %i[edit update]

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

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.avatar.attach(params[:user][:avatar]) if @user.avatar.blank?
    if @user.update(profile_params)
      redirect_to diaries_url, notice: 'プロフィールを更新しました'
    else
      @user.reload
      flash.now[:alert] = 'プロフィールの更新に失敗しました'
      render 'edit', status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def profile_params
      params.require(:user).permit(:name, :avatar)
    end
end
