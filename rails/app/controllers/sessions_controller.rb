class SessionsController < ApplicationController
  before_action :redirect_authenticated_user!, only: %i[new]
  before_action :require_login, only: %i[destroy]

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      reset_session
      log_in user
      redirect_to diaries_url, notice: 'ログインしました'
    else
      @error_message = 'メールアドレスかパスワードが間違っています'
      flash.now[:alert] = 'ログインに失敗しました'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to new_session_url, status: :see_other, notice: 'ログアウトしました'
  end
end
