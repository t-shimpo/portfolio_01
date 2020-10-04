require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user) { create(:user) }
  let!(:takashi) { create(:takashi) }

  it 'following_idとfollower_idがあれば有効であること' do
    relationship = Relationship.new(follower_id: user.id, following_id: takashi.id)
    expect(relationship).to be_valid
  end

  it 'following_idがなければ無効であること' do
    relationship = Relationship.new(follower_id: nil, following_id: takashi.id)
    expect(relationship).to_not be_valid
  end

  it 'follower_idがなければ無効であること' do
    relationship = Relationship.new(follower_id: user.id, following_id: nil)
    expect(relationship).to_not be_valid
  end
end
