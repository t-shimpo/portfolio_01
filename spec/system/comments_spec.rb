require 'rails_helper'

RSpec.feature 'Comments', type: :system do
  let!(:takashi) { create(:takashi) }
  let!(:michael) { create(:michael) }
  before do
    takashi.confirm
    michael.confirm
  end
  let!(:hibana) { create(:hibana, user_id: michael.id) }

  #--------------------
  #    コメント送信    
  #--------------------

  describe "ユーザはコメントをする", js: true  do
    before do
      login takashi
      visit post_path hibana
    end
    #  -----  有効な値  -----  #
    context '有効な値を入力する場合' do
      context 'コメント前' do
        it 'コメントフォームがあること' do
          expect(page).to have_content 'コメントはまだありません' 
          expect(page).to have_css "textarea#comment_comment_content"
        end
      end
      context 'コメント送信後' do
        before do
          fill_in 'comment_comment_content', with: '参考になります。'
          click_button '送信'
        end
        it '送信したコメントがコメント一覧に表示されること' do
          expect(page).to have_content '1件コメント' 
          expect(page).to have_content 'たかし' 
          expect(page).to have_content '参考になります。' 
        end
      end
      context 'コメント3件以上送信後' do
        before do
          fill_in 'comment_comment_content', with: '参考になります。'
          click_button '送信'
          fill_in 'comment_comment_content', with: '私も読みました'
          click_button '送信'
          fill_in 'comment_comment_content', with: 'おもしろそうです。'
          click_button '送信'
          fill_in 'comment_comment_content', with: 'お気に入りに追加しました。'
          click_button '送信'
        end
        it '3件のコメントがコメント一覧に表示されること' do
          expect(page).to have_content '参考になります。' 
          expect(page).to have_content '私も読みました' 
          expect(page).to have_content 'おもしろそうです。' 
          expect(page).to_not have_content 'お気に入りに追加しました。' 
        end
        it 'もっと見る...をクリックすると、4件のコメントがコメント一覧に表示されること' do
          find('.more', :text => 'もっと見る....').click
          expect(page).to have_content '参考になります。' 
          expect(page).to have_content '私も読みました' 
          expect(page).to have_content 'おもしろそうです。' 
          expect(page).to have_content 'お気に入りに追加しました。' 
        end
      end
    end

    #  -----  無効な値  -----  #
    context '無効な値を入力する場合' do
      it '値が空の場合、コメントが投稿されないこと' do
        fill_in 'comment_comment_content', with: ''
        click_button '送信'
        expect(page).to have_content 'コメントはまだありません' 
        expect(page).to_not have_content 'たかし' 
      end
      it '301文字以上の場合、コメントが投稿されないこと' do
        char301 = 'a' * 301
        fill_in 'comment_comment_content', with: char301
        click_button '送信'
        expect(page).to have_content 'コメントはまだありません' 
        expect(page).to_not have_content 'たかし' 
      end
    end
  end

  #--------------------
  #    コメント削除    
  #--------------------

  describe "ユーザはコメントを削除する", js: true  do
    #たかしでコメントする
    before do
      login takashi
      visit post_path hibana
      fill_in 'comment_comment_content', with: 'おもしろそうだと思いました。'
      click_button '送信'
    end
    context 'コメントしたユーザの場合' do
      it '削除ボタンが表示されていること' do
        expect(page).to have_content '1件コメント' 
        expect(page).to have_content 'たかし' 
        expect(page).to have_content '削除' 
      end
      it '削除すると一覧に表示されないこと' do
        click_link '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'コメントはまだありません' 
        expect(page).to_not have_content 'たかし' 
      end
    end

    context 'コメントをしていないユーザの場合' do
      #michaelでログインする
      before do
        logout
        login michael
        visit post_path hibana
      end
      it '削除ボタンが表示されていないこと' do
        expect(page).to have_content '1件コメント' 
        expect(page).to have_content 'たかし' 
        expect(page).to_not have_content '削除' 
      end
    end
  end
end