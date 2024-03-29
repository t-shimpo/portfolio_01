class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy
  validates :comment_content, presence: true, length: { maximum: 250 }
end
