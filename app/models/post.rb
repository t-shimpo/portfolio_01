class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :notifications, dependent: :destroy

  mount_uploader :post_image, ImageUploader

  default_scope -> { order(created_at: :desc) }

  validates :title, presence: true, length: { maximum: 100 }
  validates :author, presence: true, length: { maximum: 60 }
  validates :publisher, length: { maximum: 60 }
  validates :genre, inclusion: {
    in: %w(not_select novel business education art_ent celebrity hobby geography child others)
  }
  validates :rating, inclusion: {
    in: %w(not_select int_5 int1 int1_5 int2 int2_5 int3 int3_5 int4 int4_5 int5)
  }
  validates :hours, inclusion: {
    in: %w(not_select to10 to20 to30 to40 to50 to70 to100 from100)
  }
  validates :post_content, length: { maximum: 1000 }
  validates :user_id, presence: true
  
  enum genre: {
    not_select: 0,
    novel: 1,
    business: 2,
    education: 3,
    art_ent: 4,
    celebrity: 5,
    hobby: 6,
    geography: 7,
    child: 8,
    others: 9
  }, _prefix: true

  enum rating: {
    not_select: 0,
    int_5: 1,
    int1: 2,
    int1_5: 3,
    int2: 4,
    int2_5: 5,
    int3: 6,
    int3_5: 7,
    int4: 8,
    int4_5: 9,
    int5: 10
  }, _prefix: true

  enum hours: {
    not_select: 0,
    to10: 1,
    to20: 2,
    to30: 3,
    to40: 4,
    to50: 5,
    to70: 6,
    to100: 7,
    from100: 8
  }, _prefix: true

  def self.search(search)
    if search
      where(['title LIKE ? OR author LIKE ? OR publisher LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%"])
    else
      all
    end
  end

  def create_notification_like!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id)
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  
end