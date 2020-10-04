require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'コメント文がある場合、有効であること' do
    comment = FactoryBot.build(:comment)
    expect(comment).to be_valid
  end

  it 'post_idがnilであれば無効であること' do
    comment = FactoryBot.build(:comment, post_id: nil)
    expect(comment).to_not be_valid
  end

  it 'user_idがnilであれば無効であること' do
    comment = FactoryBot.build(:comment, user_id: nil)
    expect(comment).to_not be_valid
  end

  it 'コメント文がnilであれば無効であること' do
    comment = FactoryBot.build(:comment, comment_content: nil)
    comment.valid?
    expect(comment.errors[:comment_content]).to include('を入力してください')
  end

  it 'コメント文が250文字以内であれば有効であること' do
    char250 = 'a' * 250
    comment = FactoryBot.build(:comment, comment_content: char250)
    expect(comment).to be_valid
  end

  it 'コメント文が251文字以上であれば無効であること' do
    char251 = 'a' * 251
    comment = FactoryBot.build(:comment, comment_content: char251)
    comment.valid?
    expect(comment.errors[:comment_content]).to include('は250文字以内で入力してください')
  end
end
