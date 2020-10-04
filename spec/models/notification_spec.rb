require 'rails_helper'

RSpec.describe Notification, type: :model do
  let!(:user) { create(:user) }
  let!(:takashi) { create(:takashi) }
  let!(:hibana) { create(:hibana, user_id: takashi.id) }
  let!(:comment) { create(:comment, user_id: user.id, post_id: hibana.id) }

  it 'visitor_idとvisited_idとactionがある場合、有効であること' do
    notification = Notification.new(
      visitor_id: user.id, visited_id: takashi.id, action: 'follow', post_id: nil, comment_id: nil
    )
    expect(notification).to be_valid
  end

  it 'visitor_idとvisited_idとactionとpost_idがある場合、有効であること' do
    notification = Notification.new(
      visitor_id: user.id, visited_id: takashi.id, action: 'like', post_id: hibana.id, comment_id: nil
    )
    expect(notification).to be_valid
  end

  it 'visitor_idとvisited_idとactionとpost_idとcomment_idがある場合、有効であること' do
    notification = Notification.new(
      visitor_id: user.id, visited_id: takashi.id, action: 'comment', post_id: hibana.id, comment_id: comment.id
    )
    expect(notification).to be_valid
  end

  it 'visitor_idがない場合、無効であること' do
    notification = Notification.new(
      visitor_id: nil, visited_id: takashi.id, action: 'follow', post_id: nil, comment_id: nil
    )
    expect(notification).to be_valid
  end

  it 'visited_idがない場合、無効であること' do
    notification = Notification.new(
      visitor_id: user.id, visited_id: nil, action: 'follow', post_id: nil, comment_id: nil
    )
    expect(notification).to be_valid
  end

  it 'actionがない場合、無効であること' do
    notification = Notification.new(
      visitor_id: user.id, visited_id: takashi.id, action: nil, post_id: nil, comment_id: nil
    )
    expect(notification).to be_valid
  end
end
