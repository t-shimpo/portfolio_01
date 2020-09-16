require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "コメント文がある場合、有効であること" do
    comment = FactoryBot.build(:comment)
    expect(comment).to be_valid
  end

  it "コメント文がnilであれば無効であること" do
    comment = FactoryBot.build(:comment, comment_content: nil)
    comment.valid?
    expect(comment.errors[:comment_content]).to include("を入力してください")
  end

  it "コメント文が300文字以内であれば有効であること" do
    char300 = "a" * 300
    comment = FactoryBot.build(:comment, comment_content: char300)
    expect(comment).to be_valid
  end

  it "コメント文が301文字以上であれば無効であること" do
    char301 = "a" * 301
    comment = FactoryBot.build(:comment, comment_content: char301)
    comment.valid?
    expect(comment.errors[:comment_content]).to include("は300文字以内で入力してください")
  end
end
