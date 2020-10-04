require 'rails_helper'

RSpec.describe Like, type: :model do
  let!(:user) { create(:user) }
  let!(:post) { create(:post) }

  it 'user_idとpost_idがあれば有効であること' do
    like = Like.new(post_id: post.id, user_id: user.id)
    expect(like).to be_valid
  end

  it 'post_idがnilであれば無効であること' do
    like = Like.new(post_id: nil, user_id: user.id)
    expect(like).to_not be_valid
  end

  it 'user_idがnilであれば無効であること' do
    like = Like.new(post_id: post.id, user_id: nil)
    expect(like).to_not be_valid
  end
end
