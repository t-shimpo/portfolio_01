require 'rails_helper'

RSpec.feature 'Likes', type: :system, js: true, retry: 3 do
  let!(:takashi) { create(:takashi) }
  let!(:michael) { create(:michael) }
  before do
    takashi.confirm
    michael.confirm
  end
  let!(:hibana) { create(:hibana, user_id: michael.id) }

  describe 'ユーザは投稿にいいねをする' do
    context 'ログインユーザの場合' do
      before { login michael }
      it '投稿一覧でのいいねが成功し、いいねの数が増える' do
        visit posts_path
        expect {
          find('.fa-heart').click
          wait_for_ajax
        }.to change{ hibana.likes.count }.by(1)
        expect(find(".fa-heart")).to have_content "1"
        expect(page).to have_css('.like-red')
        visit post_path hibana
        expect(find(".fa-heart")).to have_content "1"
        expect(page).to have_css('.like-red')
      end
      it '投稿詳細でのいいねが成功し、いいねの数が増える' do
        visit post_path hibana
        expect {
          find('.fa-heart').click
          wait_for_ajax
        }.to change{ hibana.likes.count }.by(1)
        expect(find(".fa-heart")).to have_content "1"
        expect(page).to have_css('.like-red')
        visit posts_path
        expect(find(".fa-heart")).to have_content "1"
        expect(page).to have_css('.like-red')
      end
    end
    context 'ログイしていないユーザの場合' do
      it '投稿一覧のいいねボタンは反応せず、いいねの数は変わらない' do
        visit posts_path
        expect {
          find('.fa-heart').click
          wait_for_ajax
        }.to_not change(hibana.likes, :count)
        expect(find(".fa-heart")).to have_content "0"
        expect(page).to_not have_css('.like-red')
      end
    end
  end

  describe 'ユーザは投稿へのいいね取り消す' do
    before do
      login takashi
      visit posts_path
      find('.fa-heart').click
      wait_for_ajax
    end
    context 'ログインユーザの場合' do
      it '投稿一覧でのいいねの取り消しが成功し、いいねの数が減る' do
        expect(find(".fa-heart")).to have_content "1"
        expect(page).to have_css('.like-red')
        visit posts_path
        expect {
          find('.fa-heart').click
          wait_for_ajax
        }.to change{ hibana.likes.count }.by(-1)
        expect(find(".fa-heart")).to have_content "0"
        expect(page).to_not have_css('.like-red')
        visit post_path hibana
        expect(find(".fa-heart")).to have_content "0"
        expect(page).to_not have_css('.like-red')
      end
      it '投稿詳細でのいいねの取り消しが成功し、いいねの数が減る' do
        visit post_path hibana
        expect(find(".fa-heart")).to have_content "1"
        expect(page).to have_css('.like-red')
        expect {
          find('.fa-heart').click
          wait_for_ajax
        }.to change{ hibana.likes.count }.by(-1)
        expect(find(".fa-heart")).to have_content "0"
        expect(page).to_not have_css('.like-red')
        visit posts_path
        expect(find(".fa-heart")).to have_content "0"
        expect(page).to_not have_css('.like-red')
      end
    end
    context 'ログインしていないユーザの場合' do
      it '投稿一覧のいいねボタンは反応せず、いいねの数は変わらない' do
        logout
        visit posts_path
        expect {
          find('.fa-heart').click
          wait_for_ajax
        }.to_not change(hibana.likes, :count)
        expect(find(".fa-heart")).to have_content "1"
        expect(page).to_not have_css('.like-red')
      end
    end
  end

end