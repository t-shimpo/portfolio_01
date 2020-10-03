require 'rails_helper'

RSpec.feature 'Comments', type: :system, js: true, retry: 3 do
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

  describe "ユーザはコメントをする"  do
    # たかしでログインする
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
        it '投稿一覧ページにコメントマークとコメント数が表示されていないこと' do
          visit posts_path
          expect(page).to have_css('.fa-comment-alt',count: 0)
        end
      end
      context 'コメント送信後' do
        before { fill_in 'comment_comment_content', with: '参考になります。' }
        it 'コメントが増える' do
          expect {
            click_button '送信'
            wait_for_ajax
          }.to change{ hibana.comments.count }.by(1)
        end
        it '送信したコメントがコメント一覧に表示されること' do
          click_button '送信'
          wait_for_ajax
          expect(page).to have_content '1件コメント' 
          expect(page).to have_content 'たかし' 
          expect(page).to have_content '参考になります。' 
        end
        it 'コメントを送信した投稿が、マイページのコメントした投稿に表示されること' do
          click_button '送信'
          wait_for_ajax
          visit comments_user_path takashi
          expect(page).to have_content 'コメントした投稿 1 件' 
          expect(page).to have_content '火花' 
          expect(page).to have_content 'michael' 
          expect(page).to have_css('.current',count: 1)
          expect(page).to have_selector '.current', text: 'コメントした投稿'
        end
        it '投稿一覧ページにコメントマークとコメント数が表示されること' do
          click_button '送信'
          wait_for_ajax
          visit posts_path
          expect(page).to have_css('.fa-comment-alt',count: 1)
          expect(page).to have_selector '.fa-comment-alt', text: '1'
        end
      end
      context 'コメント4件送信後' do
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
          wait_for_ajax
          expect(page).to have_content '参考になります。' 
          expect(page).to have_content '私も読みました' 
          expect(page).to have_content 'おもしろそうです。' 
          expect(page).to have_content 'お気に入りに追加しました。' 
        end
        it 'コメントを送信した投稿が、マイページのコメントした投稿に表示されること' do
          visit comments_user_path takashi
          expect(page).to have_content 'コメントした投稿 4 件' 
          expect(page).to have_content '火花' 
          expect(page).to have_content 'michael' 
          expect(page).to have_css('.current',count: 1)
          expect(page).to have_selector '.current', text: 'コメントした投稿'
        end
        it '投稿一覧ページにコメントマークとコメント数が表示されること' do
          visit posts_path
          expect(page).to have_css('.fa-comment-alt',count: 1)
          expect(page).to have_selector '.fa-comment-alt', text: '4'
        end
      end
    end

    #  -----  無効な値  -----  #
    context '無効な値を入力する場合' do
      it '値が空の場合、コメントが投稿されず、エラーメッセージが表示されること' do
        fill_in 'comment_comment_content', with: ''
        expect {
          click_button '送信'
          wait_for_ajax
        }.to change{ hibana.comments.count }.by(0)
        expect(page).to have_content 'コメントはまだありません' 
        expect(page).to have_content 'コメント文を入力してください' 
        expect(page).to_not have_content 'たかし' 
      end
      it '251文字以上の場合、コメントが投稿されず、エラーメッセージが表示されること' do
        char251 = 'a' * 251
        fill_in 'comment_comment_content', with: char251
        expect {
          click_button '送信'
          wait_for_ajax
        }.to change{ hibana.comments.count }.by(0)
        expect(page).to have_content 'コメントはまだありません' 
        expect(page).to have_content 'コメント文は250文字以内で入力してください' 
        expect(page).to_not have_content 'たかし' 
      end
    end
  end

  #--------------------
  #    コメント削除    
  #--------------------

  describe "ユーザはコメントを削除する" do
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
      it 'コメントの削除に成功する' do
        expect {
          click_link '削除'
          page.driver.browser.switch_to.alert.accept
          wait_for_ajax
        }.to change{ hibana.comments.count }.by(-1)
      end
      it 'コメントを削除すると一覧に表示されないこと' do
        click_link '削除'
        page.driver.browser.switch_to.alert.accept
        wait_for_ajax
        expect(page).to have_content 'コメントはまだありません' 
        expect(page).to_not have_content 'たかし' 
      end
      it 'コメントを削除すると、マイページのコメントした投稿に表示されないこと' do
        click_link '削除'
        page.driver.browser.switch_to.alert.accept
        wait_for_ajax
        visit comments_user_path takashi
        expect(page).to have_content 'コメントした投稿 0 件' 
        expect(page).to_not have_content '火花' 
        expect(page).to_not have_content 'michael' 
        expect(page).to have_css('.current',count: 1)
        expect(page).to have_selector '.current', text: 'コメントした投稿'
      end
      it '削除後、投稿一覧ページにコメントマークとコメント数が表示されていないこと' do
        click_link '削除'
        page.driver.browser.switch_to.alert.accept
        wait_for_ajax
        visit posts_path
        expect(page).to have_css('.fa-comment-alt',count: 0)
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