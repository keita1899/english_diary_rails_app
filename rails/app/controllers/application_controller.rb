class ApplicationController < ActionController::Base
  include SessionsHelper

  private

    def redirect_authenticated_user!
      redirect_to diaries_path, alert: 'すでにログインしています' if logged_in?
    end
end
