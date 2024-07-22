class User < ApplicationRecord
  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  with_options presence: true do
    validates :name
    validates :email
    validates :password
    validates :password_confirmation
  end

  validates :name, length: { maximum: 50 }, if: -> { name.present? }
  validates :email, length: { maximum: 255 }, uniqueness: true, format: { with: VALID_EMAIL_REGEX }, if: -> { email.present? }

  has_secure_password
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
  validate :password_format, if: -> { password.present? }

  private

    def password_format
      return if password.blank?

      unless password =~ /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/
        errors.add(:password, 'は半角英数字で、英字と数字の両方を含む必要があります')
      end
    end
end
