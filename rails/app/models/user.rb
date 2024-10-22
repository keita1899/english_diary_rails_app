class User < ApplicationRecord
  before_save :downcase_email

  has_one_attached :avatar

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  with_options presence: true do
    validates :name
    validates :email
    validates :password, allow_nil: true
    validates :password_confirmation, if: -> { password.present? }
  end

  validates :name, length: { maximum: 50 }
  validates :email, length: { maximum: 255 }, uniqueness: true, format: { with: VALID_EMAIL_REGEX }, if: -> { email.present? }

  has_secure_password
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
  validate :password_format, if: -> { password.present? }

  validates :avatar,
            attached: true,
            content_type: ['image/png', 'image/jpg', 'image/jpeg'],
            size: { less_than: 1.megabytes },
            dimension: { width: { in: 32..1024 }, height: { in: 32..1024 } },
            on: :update

  def avatar_url
    avatar.attached? ? avatar : ActionController::Base.helpers.asset_path('default_avatar.png')
  end

  private

    def downcase_email
      self.email = email.downcase
    end

    def password_format
      unless password =~ /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/
        errors.add(:password, 'は半角英数字で、少なくとも1つの英字と1つの数字を含む必要があります')
      end
    end
end
