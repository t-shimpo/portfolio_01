require 'rails_helper'

RSpec.feature 'Notifications', type: :system, js: true do
  let!(:takashi) { create(:takashi) }
  let!(:michael) { create(:michael) }
  let!(:kenji) { create(:kenji) }
  before do
    takashi.confirm
    michael.confirm
    kenji.confirm
    login takashi
  end
  let!(:hibana) { create(:hibana, user_id: michael.id) }

  describe 'フォロー・いいね・コメントをされると通知される' do
    context 'フォローの場合' do
      # michaelをいいねする
      before { visit user_path michael }
      it '通知が増える' do
        expect {
          click_button 'フォローする'
          wait_for_ajax(15)
        }.to change { Notification.count }.by(1)
      end
      it 'フォローされたユーザに1件通知が表示される' do
        click_button 'フォローする'
        wait_for_ajax
        logout
        login michael
        click_link '通知'
        expect(page).to have_css('.notification', count: 1)
        expect(page).to have_content 'たかし さんが あなたをフォローしました'
        click_link 'たかし'
        expect(current_path).to eq user_path takashi
      end
      it 'フォローし、フォローを解除し、再度フォローしても1件のみ通知が表示される' do
        click_button 'フォローする'
        wait_for_ajax
        click_button 'フォロー中'
        wait_for_ajax
        click_button 'フォローする'
        wait_for_ajax
        logout
        login michael
        click_link '通知'
        expect(page).to have_css('.notification', count: 1)
        expect(page).to have_content 'たかし さんが あなたをフォローしました'
        click_link 'たかし'
        expect(current_path).to eq user_path takashi
      end
      it '通知を見る前は、通知リンク付近に印がついており、通知を見るとそれが消える' do
        click_button 'フォローする'
        wait_for_ajax
        logout
        login michael
        expect(page).to have_css('.fa-circle', count: 1)
        click_link '通知'
        expect(page).to have_css('.fa-circle', count: 0)
      end
    end
    context 'いいねの場合' do
      # michaelの投稿「火花」にいいねする
      before { visit post_path hibana }
      it '通知が増える' do
        expect {
          find('.fa-heart').click
          wait_for_ajax
        }.to change { Notification.count }.by(1)
      end
      it '投稿にいいねされたユーザに1件通知が表示される' do
        find('.fa-heart').click
        wait_for_ajax
        logout
        login michael
        click_link '通知'
        expect(page).to have_css('.notification', count: 1)
        expect(page).to have_content 'たかし さんが あなたの投稿にいいねしました'
        click_link 'たかし'
        expect(current_path).to eq user_path takashi
        click_link '通知'
        click_link 'あなたの投稿'
        expect(current_path).to eq post_path hibana
      end
      it '通知を見る前は、通知リンク付近に印がついており、通知を見るとそれが消える' do
        find('.fa-heart').click
        wait_for_ajax
        logout
        login michael
        expect(page).to have_css('.fa-circle', count: 1)
        click_link '通知'
        expect(page).to have_css('.fa-circle', count: 0)
      end
      it 'いいねし、いいねを解除し、再度いいねしても1件のみ通知が表示される' do
        find('.fa-heart').click
        wait_for_ajax
        find('.fa-heart').click
        wait_for_ajax
        find('.fa-heart').click
        wait_for_ajax
        logout
        login michael
        click_link '通知'
        expect(page).to have_css('.notification', count: 1)
        expect(page).to have_content 'たかし さんが あなたの投稿にいいねしました'
        click_link 'たかし'
        expect(current_path).to eq user_path takashi
        click_link '通知'
        click_link 'あなたの投稿'
        expect(current_path).to eq post_path hibana
      end
    end
    context 'コメントの場合' do
      context '投稿にコメントされた場合' do
        # michaelの投稿「火花」にコメントする
        before do
          visit post_path hibana
          fill_in 'comment_comment_content', with: '参考になります。'
        end
        it '通知が増える' do
          expect {
            click_button '送信'
            wait_for_ajax
          }.to change { Notification.count }.by(1)
        end
        it '投稿ユーザに1件通知が表示される' do
          click_button '送信'
          wait_for_ajax
          logout
          login michael
          click_link '通知'
          expect(page).to have_css('.notification', count: 1)
          expect(page).to have_content 'たかし さんが あなたの投稿にコメントしました'
          expect(page).to have_content '参考になります。'
          click_link 'たかし'
          expect(current_path).to eq user_path takashi
          click_link '通知'
          click_link 'あなたの投稿'
          expect(current_path).to eq post_path hibana
        end
        it '通知を見る前は、通知リンク付近に印がついており、通知を見るとそれが消える' do
          click_button '送信'
          wait_for_ajax
          logout
          login michael
          expect(page).to have_css('.fa-circle', count: 1)
          click_link '通知'
          expect(page).to have_css('.fa-circle', count: 0)
        end
        it '2件コメントされた場合2件通知が表示される' do
          click_button '送信'
          wait_for_ajax
          fill_in 'comment_comment_content', with: '面白かったです！'
          click_button '送信'
          wait_for_ajax
          logout
          login michael
          click_link '通知'
          expect(page).to have_css('.notification', count: 2)
          expect(page).to have_content 'たかし さんが あなたの投稿にコメントしました'
          expect(page).to have_content '参考になります。'
          expect(page).to have_content '面白かったです！'
        end
      end
      context 'あるユーザがコメントした投稿に、さらに別人物がコメントした場合' do
        # たかしがmichaelの投稿「火花」にコメントし、
        # その後けんじmichaelの投稿「火花」にコメントし、
        # 再度たかしでログインする
        before do
          visit post_path hibana
          fill_in 'comment_comment_content', with: '参考になります。'
          click_button '送信'
          wait_for_ajax
          logout
          login kenji
          visit post_path hibana
          fill_in 'comment_comment_content', with: '面白いですね！'
          click_button '送信'
          wait_for_ajax
        end
        it '投稿ユーザに2件通知が表示される' do
          logout
          login michael
          click_link '通知'
          expect(page).to have_css('.notification', count: 2)
          expect(page).to have_content 'たかし さんが あなたの投稿にコメントしました'
          expect(page).to have_content 'けんじ さんが あなたの投稿にコメントしました'
          expect(page).to have_content '参考になります。'
          expect(page).to have_content '面白いですね！'
        end
        it 'はじめに投稿にコメントしたユーザに1件通知が表示される' do
          logout
          login takashi
          expect(page).to have_css('.fa-circle', count: 1)
          click_link '通知'
          expect(page).to have_css('.notification', count: 1)
          expect(page).to have_content 'けんじ さんが michaelさんの投稿 にコメントしました'
          expect(page).to have_content '面白いですね！'
          click_link 'けんじ'
          expect(current_path).to eq user_path kenji
          click_link '通知'
          click_link 'michaelさんの投稿'
          expect(current_path).to eq post_path hibana
        end
      end
    end
  end

  describe '表示されている通知を削除する' do
    before do
      visit user_path michael
      click_button 'フォローする'
      wait_for_ajax
      visit post_path hibana
      find('.fa-heart').click
      wait_for_ajax
      logout
      login michael
      click_link '通知'
    end
    it '表示されている通知が表示されなくなる' do
      expect(page).to have_css('.notification', count: 2)
      click_link '全削除'
      page.driver.browser.switch_to.alert.accept
      wait_for_ajax
      expect(page).to have_css('.notification', count: 0)
    end
    it '削除ボタンが表示されなくなる' do
      expect(page).to have_content '全削除'
      click_link '全削除'
      page.driver.browser.switch_to.alert.accept
      wait_for_ajax
      expect(page).to_not have_content '全削除'
    end
  end
end
