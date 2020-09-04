class Post < ApplicationRecord
  belongs_to :user

  mount_uploader :post_image, ImageUploader

  default_scope -> { order(created_at: :desc) }

  validates :title, presence: true, length: { maximum: 200 }
  validates :author, presence: true, length: { maximum: 100 }
  validates :publisher, length: { maximum: 100 }
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
  
end
