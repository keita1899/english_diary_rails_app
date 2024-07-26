require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  before do
    driven_by(:rack_test)
  end

  def fill_in_login_form(email:, password:)
    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: password
    click_button 'ログイン'
  end

  describe 'ログイン' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    context 'ログインしていない場合' do
      before do
        visit new_session_path
      end

      it 'ログインページにアクセスが成功する' do
        expect(current_path).to eq(new_session_path)
        expect(page).to have_title 'ログイン | English Diary'
        expect(page).to have_link 'ログイン'
        expect(page).to have_link '新規登録'
      end

      it '正しい値を入力するとログインが成功する' do
        fill_in_login_form(email: user.email, password: user.password)

        expect(current_path).to eq(diaries_path)
        expect(page).to have_content 'ログインしました'
        expect(page).to have_content user.name
        find('.menu').click
        expect(page).to have_link 'ログアウト'
      end

      it '間違ったメールアドレスを入力するとログインが失敗する' do
        fill_in_login_form(email: nil, password: user.password)

        expect(page).to have_content 'メールアドレスかパスワードが間違っています'
        expect(page).to have_content 'ログインに失敗しました'
      end

      it '間違ったパスワードを入力するとログインが失敗する' do
        fill_in_login_form(email: user.email, password: nil)

        expect(page).to have_content 'メールアドレスかパスワードが間違っています'
        expect(page).to have_content 'ログインに失敗しました'
      end
    end

    context 'ログインしている場合' do
      before do
        sign_in_as user
      end

      it 'ログインページにアクセスするとカレンダーページにリダイレクトする' do
        visit new_session_path

        expect(page).to have_title 'カレンダー | English Diary'
        expect(page).to have_content 'すでにログインしています'
      end
    end
  end
end
