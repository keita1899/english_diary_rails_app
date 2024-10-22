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

  describe 'プロフィール' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    context 'ログインしていない場合' do
      it 'プロフィールページにアクセスするとログインページにリダイレクトされる' do
        visit profile_path

        expect(current_path).to eq(new_session_path)
        expect(page).to have_content 'ログインが必要です'
      end
    end

    context 'ログインしている場合' do
      before do
        sign_in_as user
      end

      it 'プロフィールページにアクセスが成功する' do
        visit profile_path

        expect(page).to have_title 'プロフィール | English Diary'
      end

      it '名前と画像ファイルを入力するとプロフィールの更新が成功する' do
        visit profile_path
        expect(page).to have_selector("img[src*='default_avatar']")

        fill_in '名前', with: 'test'
        attach_file 'user[avatar]', "#{Rails.root}/spec/files/avatar.png"
        click_button '更新'

        user.reload

        expect(page).to have_content 'プロフィールを更新しました'
        expect(page).to have_content user.name
        expect(page).to have_selector("img[src*='avatar']")
      end

      it '名前が空だとプロフィールの更新が失敗する' do
        visit profile_path
        expect(page).to have_selector("img[src*='default_avatar']")

        fill_in '名前', with: nil
        attach_file 'user[avatar]', "#{Rails.root}/spec/files/avatar.png"

        click_button '更新'

        user.reload

        expect(page).to have_content 'プロフィールの更新に失敗しました'
        expect(page).to have_content '名前を入力してください'
        expect(page).to have_content user.name
      end
    end
  end
end
