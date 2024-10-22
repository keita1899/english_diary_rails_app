class ApplicationController < ActionController::Base
  include SessionsHelper

  private

    def require_login
      redirect_to new_session_path, alert: 'ログインが必要です' unless logged_in?
    end

    def redirect_authenticated_user!
      redirect_to diaries_path, alert: 'すでにログインしています' if logged_in?
    end
end
