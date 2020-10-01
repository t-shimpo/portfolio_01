class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :commented_posts, through: :comments, source: :post
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship",  dependent: :destroy
  has_many :following, through: :following_relationships
  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships

  mount_uploader :image, ImageUploader

  validates :nickname, presence: true, length: { maximum: 50 }

  def self.guest
    find_or_create_by(email: 'guestuser@example.com') do |user|
      user.password = Rails.application.credentials.guest_user_password
    end
  end

  def already_liked?(post)
    self.likes.exists?(post_id: post.id)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def follow(other_user)
    following_relationships.create!(following_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationships.find_by(following_id: other_user.id).destroy
  end

  def feed
    Post.where("user_id IN (?)", following_ids)
  end

  def self.search(search)
    if search
      where(['nickname LIKE ?', "%#{search}%"])
    else
      all
    end
  end

end
