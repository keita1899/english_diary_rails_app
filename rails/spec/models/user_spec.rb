require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { build(:user) }
  let(:invalid_emails) do
    [
      'plainaddress',
      'test@',
      '@example.com',
      'test@.com',
      'test@com',
      'test@exa_mple.com',
      'test@example',
      'test@subdomain@example.com',
    ]
  end
  let(:invalid_passwords) do
    [
      'パスワード123',
      'password!@#',
      '12345678',
      'password',
      'password@123',
      'password1234!',
    ]
  end

  describe 'コールバック' do
    let!(:user) { create(:user, email: 'TEST@EXAMPLE.COM') }

    it 'メールアドレスが保存される前に小文字に変換される' do
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'バリデーション' do
    it '正しく入力すると成功する' do
      expect(user).to be_valid
    end

    it '名前が空だと失敗する' do
      user.name = nil
      expect(user).to be_invalid
      expect(user.errors[:name]).to include('を入力してください')
    end

    it 'メールアドレスが空だと失敗する' do
      user.email = nil
      expect(user).to be_invalid
      expect(user.errors[:email]).to include('を入力してください')
    end

    it 'パスワードが空だと失敗する' do
      user.password = nil
      expect(user).to be_invalid
      expect(user.errors[:password]).to include('を入力してください')
    end

    it '確認用パスワードが空だと失敗する' do
      user.password_confirmation = nil
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include('を入力してください')
    end

    it '名前が50文字であれば成功する' do
      user.name = 'a' * 50
      expect(user).to be_valid
    end

    it '名前が51文字であれば失敗する' do
      user.name = 'a' * 51
      expect(user).to be_invalid
      expect(user.errors[:name]).to include('は50文字以内で入力してください')
    end

    it 'メールアドレスが255文字であれば成功する' do
      user.email = "#{"a" * 243}@example.com"
      expect(user).to be_valid
    end

    it 'メールアドレスが256文字であれば失敗する' do
      user.email = "#{"a" * 244}@example.com"
      expect(user).to be_invalid
      expect(user.errors[:email]).to include('は255文字以内で入力してください')
    end

    it 'パスワードが7文字であれば失敗する' do
      user.password = 'a' * 7
      user.password_confirmation = user.password
      expect(user).to be_invalid
      expect(user.errors[:password]).to include('は半角英数字で、英字と数字の両方を含む必要があります')
    end

    it 'パスワードが8文字であれば成功する' do
      user.password = 'a1' * 4
      user.password_confirmation = user.password
      expect(user).to be_valid
    end

    it 'パスワードが9文字であれば成功する' do
      user.password = "#{"a1" * 4}a"
      user.password_confirmation = user.password
      expect(user).to be_valid
    end

    it 'パスワードが72文字であれば成功する' do
      user.password = 'a1' * 36
      user.password_confirmation = user.password
      expect(user).to be_valid
    end

    it 'パスワードが73文字であれば失敗する' do
      user.password = "#{"a1" * 36}a"
      user.password_confirmation = user.password
      expect(user).to be_invalid
      expect(user.errors[:password]).to include('は72文字以内で入力してください')
    end

    it 'メールアドレスが重複しているときは失敗する' do
      create(:user, email: 'duplicate@example.com')
      user.email = 'duplicate@example.com'
      expect(user).to be_invalid
    end

    it 'メールアドレスの形式が間違っているとき' do
      invalid_emails.each do |email|
        user = User.new(
          name: 'Test User',
          email:,
          password: 'password123',
          password_confirmation: 'password123',
        )
        expect(user).to be_invalid
      end
    end

    it 'パスワードの形式が半角英数字ではないときは失敗する' do
      invalid_passwords.each do |password|
        user = User.new(
          name: 'Test User',
          email: 'test@example.com',
          password:,
          password_confirmation: password,
        )
        expect(user).to be_invalid
        expect(user.errors[:password]).to include('は半角英数字で、英字と数字の両方を含む必要があります')
      end
    end

    it 'パスワードと確認用のパスワードが異なるときは失敗する' do
      user.password_confirmation = 'different_password123'
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
    end
  end
end
