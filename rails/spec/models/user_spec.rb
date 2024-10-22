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
      expect(user.errors[:password]).to include('は8文字以上で入力してください')
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

    it 'メールアドレスが大文字でも成功する' do
      create(:user, email: 'test@example.com')
      duplicate_user = build(:user, email: 'TEST@EXAMPLE.COM')
      expect(duplicate_user).to be_valid
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
        expect(user.errors[:password]).to include('は半角英数字で、少なくとも1つの英字と1つの数字を含む必要があります')
      end
    end

    it 'パスワードと確認用のパスワードが異なるときは失敗する' do
      user.password_confirmation = 'different_password123'
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
    end
  end

  describe 'アバター画像バリデーション' do
    it 'アバター画像が空だと失敗する' do
      expect(subject).to validate_attached_of(:avatar).on(:update)
    end

    it 'アバター画像のファイル形式がpngかjpegだと成功する' do
      expect(subject).to validate_content_type_of(:avatar).allowing('image/png', 'image/jpeg').on(:update)
    end

    it 'アバター画像のファイル形式がgifだと失敗する' do
      expect(subject).to validate_content_type_of(:avatar).rejecting('image/gif').on(:update)
    end

    it 'アバター画像のファイル形式が画像ファイル以外だと失敗する' do
      expect(subject).to validate_content_type_of(:avatar).rejecting(
        'text/plain', 'text/xml', 'application/msword', 'application/pdf',
        'application/vnd.ms-excel', 'application/zip', 'audio/mpeg',
        'video/mp4', 'text/html', 'application/xml'
      ).on(:update)
    end

    it 'アバター画像のファイルサイズが1MB未満だと成功する' do
      expect(subject).to validate_size_of(:avatar).less_than(1.megabytes).on(:update)
    end

    it 'アバター画像のファイルサイズが1MB以上だと失敗する' do
      expect(subject).not_to validate_size_of(:avatar).greater_than_or_equal_to(1.megabytes).on(:update)
    end

    it 'アバター画像のwidthが32から1024ピクセルの間だと成功する' do
      expect(subject).to validate_dimensions_of(:avatar).width_between(32..1024).on(:update)
    end

    it 'アバター画像のwidthが31ピクセルだと失敗する' do
      expect(subject).not_to validate_dimensions_of(:avatar).width(31).on(:update)
    end

    it 'アバター画像のwidthが1025ピクセルだと失敗する' do
      expect(subject).not_to validate_dimensions_of(:avatar).width(1025).on(:update)
    end

    it 'アバター画像のheightが32から1024ピクセルの間だと成功する' do
      expect(subject).to validate_dimensions_of(:avatar).height_between(32..1024).on(:update)
    end

    it 'アバター画像のheightが31ピクセルだと失敗する' do
      expect(subject).not_to validate_dimensions_of(:avatar).height(31).on(:update)
    end

    it 'アバター画像のheightが1025ピクセルだと失敗する' do
      expect(subject).not_to validate_dimensions_of(:avatar).height(1025).on(:update)
    end
  end
end
