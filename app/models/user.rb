class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :nickname, presence: true, length: { maximum: 50 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
end