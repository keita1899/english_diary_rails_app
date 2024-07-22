require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
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

        fill_in '名前', with: valid_attributes[:name]
        fill_in 'メールアドレス', with: valid_attributes[:email]
        fill_in 'パスワード', with: valid_attributes[:password]
        fill_in 'パスワード（確認用）', with: valid_attributes[:password_confirmation]

        click_button '登録'
      }.to change { User.count }.by(1)

      expect(current_path).to eq(root_path)

      expect(page).to have_content '新規登録が完了しました'
    end

    it '間違った値を入力すると失敗する' do
      visit signup_path

      fill_in '名前', with: invalid_attributes[:name]
      fill_in 'メールアドレス', with: invalid_attributes[:email]
      fill_in 'パスワード', with: invalid_attributes[:password]
      fill_in 'パスワード（確認用）', with: invalid_attributes[:password_confirmation]

      click_button '登録'

      expect(User.count).to eq(0)

      expect(current_path).to eq(users_path)
      expect(page).to have_content '名前を入力してください'
      expect(page).to have_content '新規登録に失敗しました'
    end
  end
end
