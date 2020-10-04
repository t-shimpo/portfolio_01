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
      # たかしでログインする
      before { login takashi }
      it '投稿一覧でハートのアイコンをクリックすると、いいねの数が増える' do
        visit posts_path
        expect {
          find('.fa-heart').click
          wait_for_ajax
        }.to change { hibana.likes.count }.by(1)
        expect(find('.fa-heart')).to have_content '1'
        expect(page).to have_css('.like-red')
        visit post_path hibana
        expect(find('.fa-heart')).to have_content '1'
        expect(page).to have_css('.like-red')
      end
      it '投稿詳細でハートのアイコンをクリックすると、いいねの数が増える' do
        visit post_path hibana
        expect {
          find('.fa-heart').click
          wait_for_ajax
        }.to change { hibana.likes.count }.by(1)
        expect(find('.fa-heart')).to have_content '1'
        expect(page).to have_css('.like-red')
        visit posts_path
        expect(find('.fa-heart')).to have_content '1'
        expect(page).to have_css('.like-red')
      end
      it '投稿一覧でいいねした投稿がマイページのいいねした投稿ページに表示される' do
        visit posts_path
        find('.fa-heart').click
        wait_for_ajax
        visit user_path takashi
        click_link 'いいね'
        expect(page).to have_content 'いいねした投稿 1 件'
        expect(page).to have_content '火花'
        expect(page).to have_css('.current', count: 1)
        expect(page).to have_selector '.current', text: 'いいね'
      end
      it '投稿詳細でいいねした投稿がマイページのいいねした投稿ページに表示される' do
        visit post_path hibana
        find('.fa-heart').click
        wait_for_ajax
        visit user_path takashi
        click_link 'いいね'
        expect(page).to have_content 'いいねした投稿 1 件'
        expect(page).to have_content '火花'
        expect(page).to have_css('.current', count: 1)
        expect(page).to have_selector '.current', text: 'いいね'
      end
      it 'いいねをしたユーザが、いいねしたユーザページに表示される' do
        visit post_path hibana
        find('.fa-heart').click
        wait_for_ajax
        click_link 'いいねしたユーザ'
        expect(page).to have_content 'michael'
        expect(page).to have_content '火花'
        expect(page).to have_content '又吉直樹'
        expect(page).to have_content 'いいねしたユーザ 1 人'
        expect(page).to have_content 'たかし'
      end
    end
    context 'ログイしていないユーザの場合' do
      it '投稿一覧のいいねボタンは反応せず、いいねの数は変わらない' do
        visit posts_path
        expect {
          find('.fa-heart').click
          wait_for_ajax
        }.to_not change(hibana.likes, :count)
        expect(find('.fa-heart')).to have_content '0'
        expect(page).to_not have_css('.like-red')
      end
    end
  end

  describe 'ユーザは投稿へのいいね取り消す' do
    # たかしでログイン
    before do
      login takashi
      visit posts_path
      find('.fa-heart').click
      wait_for_ajax
    end
    context 'ログインユーザの場合' do
      it '投稿一覧でハートのアイコンをクリックすると、いいねの数が減る' do
        expect(find('.fa-heart')).to have_content '1'
        expect(page).to have_css('.like-red')
        visit posts_path
        expect {
          find('.fa-heart').click
          wait_for_ajax
        }.to change { hibana.likes.count }.by(-1)
        expect(find('.fa-heart')).to have_content '0'
        expect(page).to_not have_css('.like-red')
        visit post_path hibana
        expect(find('.fa-heart')).to have_content '0'
        expect(page).to_not have_css('.like-red')
      end
      it '投稿詳細でハートのアイコンをクリックすると、いいねの数が減る' do
        visit post_path hibana
        expect(find('.fa-heart')).to have_content '1'
        expect(page).to have_css('.like-red')
        expect {
          find('.fa-heart').click
          wait_for_ajax
        }.to change { hibana.likes.count }.by(-1)
        expect(find('.fa-heart')).to have_content '0'
        expect(page).to_not have_css('.like-red')
        visit posts_path
        expect(find('.fa-heart')).to have_content '0'
        expect(page).to_not have_css('.like-red')
      end
      it '投稿一覧でいいねを取り消した投稿がマイページのいいねした投稿ページに表示されない' do
        visit posts_path
        find('.fa-heart').click
        wait_for_ajax
        visit user_path michael
        click_link 'いいね'
        expect(page).to have_content 'いいねした投稿 0 件'
        expect(page).to_not have_content '火花'
        expect(page).to have_css('.current', count: 1)
        expect(page).to have_selector '.current', text: 'いいね'
      end
      it '投稿詳細でいいねを取り消した投稿がマイページのいいねした投稿ページに表示されない' do
        visit post_path hibana
        find('.fa-heart').click
        wait_for_ajax
        visit user_path michael
        click_link 'いいね'
        expect(page).to have_content 'いいねした投稿 0 件'
        expect(page).to_not have_content '火花'
        expect(page).to have_css('.current', count: 1)
        expect(page).to have_selector '.current', text: 'いいね'
      end
      it 'いいねを取り消したユーザが、いいねしたユーザページに表示されない' do
        visit post_path hibana
        find('.fa-heart').click
        wait_for_ajax
        click_link 'いいねしたユーザ'
        expect(page).to have_content 'michael'
        expect(page).to have_content '火花'
        expect(page).to have_content '又吉直樹'
        expect(page).to have_content 'いいねしたユーザ 0 人'
        expect(page).to_not have_content 'たかし'
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
        expect(find('.fa-heart')).to have_content '1'
        expect(page).to_not have_css('.like-red')
      end
    end
  end
end
