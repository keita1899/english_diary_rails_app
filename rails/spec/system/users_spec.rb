require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
  end

  def fill_in_signup_form(user_params)
    fill_in '名前', with: user_params[:name]
    fill_in 'メールアドレス', with: user_params[:email]
    fill_in 'パスワード', with: user_params[:password]
    fill_in 'パスワード（確認用）', with: user_params[:password_confirmation]

    click_button '登録'
  end

  describe '新規登録' do
    let(:valid_attributes) do
      {
        name: 'Test',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123',
      }
    end

    let(:invalid_attributes) do
      {
        name: nil,
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123',
      }
    end

    it '正しい値を入力すると成功する' do
      expect {
        visit signup_path

        fill_in_signup_form(valid_attributes)
      }.to change { User.count }.by(1)

      expect(current_path).to eq(diaries_path)
      expect(page).to have_content '新規登録が完了しました'
    end

    it '間違った値を入力すると失敗する' do
      visit signup_path

      fill_in_signup_form(invalid_attributes)

      expect(User.count).to eq(0)
      expect(current_path).to eq(users_path)
      expect(page).to have_content '名前を入力してください'
      expect(page).to have_content '新規登録に失敗しました'
    end

    context 'ログインしている場合' do
      let!(:user) { create(:user) }

      before do
        sign_in_as user
      end

      it '新規登録ページにアクセスするとカレンダーページにリダイレクトする' do
        visit signup_path

        expect(page).to have_title 'カレンダー | English Diary'
        expect(page).to have_content 'すでにログインしています'
      end
    end
  end
end
