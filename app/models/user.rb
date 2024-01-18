class User < ApplicationRecord
    has_many :documents
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true, length: { minimum: 6, maximum: 30 }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validates :password, length: { minimum: 8 }, allow_blank: false, on: :update
  # Additional validations for password
  # validate :password_minimum_length, :password_complexity, on: :update

  private

  def password_minimum_length
    if password.present? && password.length < 8
      errors.add :password, "must be at least 8 characters long"
    end
  end

  def password_complexity
    if password.present? && !password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/)
      errors.add :password, "must include at least one lowercase letter, one uppercase letter, and one digit"
    end
  end

end
