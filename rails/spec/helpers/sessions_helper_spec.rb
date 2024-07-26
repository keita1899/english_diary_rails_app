require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { create(:user) }

  describe '#log_in' do
    it 'セッションにuser_idを格納する' do
      log_in(user)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe '#current_user' do
    context 'ログインしている場合' do
      it 'ログインしているユーザーを返す' do
        log_in(user)
        expect(current_user).to eq(user)
      end
    end

    context 'ログインしていない場合' do
      it 'nilを返す' do
        expect(current_user).to be_nil
      end
    end
  end

  describe '#logged_in?' do
    context 'ログインしている場合' do
      it 'trueを返す' do
        log_in(user)
        expect(logged_in?).to be(true)
      end
    end

    context 'ログインしていない場合' do
      it 'falseを返す' do
        expect(logged_in?).to be(false)
      end
    end
  end
end
