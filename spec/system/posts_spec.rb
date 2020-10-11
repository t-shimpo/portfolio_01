require 'rails_helper'

RSpec.feature 'Posts', type: :system do
  let!(:kenji) { create(:kenji) }
  before do
    kenji.confirm
    # けんじでログインする
    login kenji
  end

  #--------------------#
  #      投稿する      #
  #--------------------#

  describe 'ユーザは投稿する' do
    #  -----  有効な値  -----  #

    context '有効な値を入力する場合' do
      before do
        visit new_post_path
        attach_file 'post_post_image', 'spec/file/test_image.png'
        fill_in 'post_title', with: '流浪の月'
        fill_in 'post_author', with: '凪良ゆう'
        fill_in 'post_publisher', with: '東京創元社'
        select '小説・文学', from: 'ジャンル'
        select '3.5', from: '評価（1~5）'
        select '30〜40時間', from: '読むのにかかった時間'
        fill_in 'post_purchase_date', with: '2019-2-21'
        fill_in 'post_post_content', with: '正しい生き方は何か、考えさせられました。'
      end
      it '投稿されること' do
        expect {
          click_button '投稿する'
        }.to change { Post.count }.by(1)
      end
      it '投稿が成功したメッセージが表示されること' do
        click_button '投稿する'
        expect(page).to have_content '投稿されました。'
        expect(current_path).to eq new_post_path
      end
      it '投稿が、本を探すの投稿一覧に表示されること' do
        click_button '投稿する'
        visit posts_path
        expect(page).to have_content '流浪の月'
        expect(page).to have_content 'けんじ'
      end
      it '投稿が、マイページの最新の投稿に表示されること' do
        click_button '投稿する'
        visit user_path kenji
        expect(page).to have_content '流浪の月'
        expect(page).to have_css('.current', count: 1)
        expect(page).to have_selector '.current', text: 'トップ'
      end
      it '投稿が、マイページの投稿一覧に表示されること' do
        click_button '投稿する'
        visit  posts_user_path kenji
        expect(page).to have_content '投稿一覧 1 件'
        expect(page).to have_content '流浪の月'
        expect(page).to have_css('.current', count: 1)
        expect(page).to have_selector '.current', text: '投稿一覧'
      end
      it '投稿した情報が、投稿の詳細ページに表示されること' do
        click_button '投稿する'
        visit posts_path
        click_link '流浪の月'
        expect(page).to have_content '編集する'
        expect(page).to have_selector("img[src$='test_image.png']")
        expect(page).to have_content '流浪の月'
        expect(page).to have_content '凪良ゆう'
        expect(page).to have_content '東京創元社'
        expect(page).to have_content '小説・文学'
        expect(page).to have_content '3.5'
        expect(page).to have_content '30〜40時間'
        expect(page).to have_content '2019-02-21'
        expect(page).to have_content '正しい生き方は何か、考えさせられました。'
      end
      it '投稿した情報が、投稿編集ページに表示されること' do
        click_button '投稿する'
        visit posts_path
        click_link '流浪の月'
        click_link '編集する'
        expect(page).to have_selector("img[src$='test_image.png']")
        expect(page).to have_xpath "//input[@id='post_title'][@value='流浪の月']"
        expect(page).to have_xpath "//input[@id='post_author'][@value='凪良ゆう']"
        expect(page).to have_xpath "//input[@id='post_publisher'][@value='東京創元社']"
        expect(page).to have_select('ジャンル', selected: '小説・文学')
        expect(page).to have_select('評価', selected: '3.5')
        expect(page).to have_select('読むのにかかった時間', selected: '30〜40時間')
        expect(page).to have_xpath "//input[@id='post_purchase_date'][@value='2019-02-21']"
        expect(page).to have_field '感想', with: '正しい生き方は何か、考えさせられました。'
      end
      it '画像をアップロードしなかった場合、デフォルトの画像が表示されること' do
        click_button '投稿する'
        visit new_post_path
        fill_in 'post_title', with: '逆ソクラテス'
        fill_in 'post_author', with: '伊坂幸太郎'
        click_button '投稿する'
        visit posts_path
        expect(page).to have_css '.default-post-image'
        expect(page).to have_content '逆ソクラテス'
        click_link '逆ソクラテス'
        expect(page).to have_css '.default-post-image'
        click_link '編集する'
        expect(page).to have_css '.default-post-image'
      end
    end

    #  -----  無効な値  -----  #

    context '無効な値を入力する場合' do
      before { visit new_post_path }
      it '投稿されないこと' do
        fill_in 'post_title', with: ''
        fill_in 'post_author', with: ''
        expect {
          click_button '投稿する'
        }.to change { Post.count }.by(0)
      end
      it '値が空の場合、エラーメッセージが表示されること' do
        fill_in 'post_title', with: ''
        fill_in 'post_author', with: ''
        click_button '投稿する'
        expect(page).to have_content '投稿 は保存されませんでした。'
        expect(page).to have_content 'タイトルを入力してください'
        expect(page).to have_content '著者を入力してください'
      end
      it 'タイトルが101文字以上の場合、エラーメッセージが表示されること' do
        char101 = 'a' * 101
        fill_in 'post_title', with: char101
        click_button '投稿する'
        expect(page).to have_content '投稿 は保存されませんでした。'
        expect(page).to have_content 'タイトルは100文字以内で入力してください'
      end
      it '著者が61文字以上の場合、エラーメッセージが表示されること' do
        char61 = 'a' * 61
        fill_in 'post_author', with: char61
        click_button '投稿する'
        expect(page).to have_content '投稿 は保存されませんでした。'
        expect(page).to have_content '著者は60文字以内で入力してください'
      end
      it '出版社が61文字以上の場合、エラーメッセージが表示されること' do
        char61 = 'a' * 61
        fill_in 'post_publisher', with: char61
        click_button '投稿する'
        expect(page).to have_content '投稿 は保存されませんでした。'
        expect(page).to have_content '出版社は60文字以内で入力してください'
      end
      it '感想が1001文字以上の場合、エラーメッセージが表示されること' do
        char1001 = 'a' * 1001
        fill_in 'post_post_content', with: char1001
        click_button '投稿する'
        expect(page).to have_content '投稿 は保存されませんでした。'
        expect(page).to have_content '感想は1000文字以内で入力してください'
      end
    end
  end

  #--------------------#
  #    投稿の更新      #
  #--------------------#

  describe 'ユーザは投稿後、投稿を更新する' do
    #  -----  有効な値  -----  #

    context '有効な値を入力する場合' do
      before do
        visit new_post_path
        fill_in 'post_title', with: '流浪の月'
        fill_in 'post_author', with: '凪良ゆう'
        click_button '投稿する'
        visit posts_path
        click_link '流浪の月'
        click_link '編集する'
        attach_file 'post_post_image', 'spec/file/test_image.png'
        fill_in 'post_title', with: '逆ソクラテス'
        fill_in 'post_author', with: '伊坂幸太郎'
        fill_in 'post_publisher', with: '集英社'
        select '小説・文学', from: 'ジャンル'
        select '4', from: '評価（1~5）'
        select '20〜30時間', from: '読むのにかかった時間'
        fill_in 'post_purchase_date', with: '2019-10-20'
        fill_in 'post_post_content', with: '時間を忘れて読みました。'
      end
      it '更新が成功したメッセージが表示されること' do
        click_button '更新する'
        expect(page).to have_content '投稿は更新されました。'
        expect(current_path).to eq post_path kenji.posts.last
      end
      it '更新したタイトルが本を探すの投稿一覧に表示されること' do
        click_button '更新する'
        visit posts_path
        expect(page).to have_content '逆ソクラテス'
        expect(page).to_not have_content '流浪の月'
        expect(page).to have_content 'けんじ'
      end
      it '更新した投稿が、マイページの最新の投稿に表示されること' do
        click_button '更新する'
        visit user_path kenji
        expect(page).to have_content '逆ソクラテス'
        expect(page).to have_css('.current', count: 1)
        expect(page).to have_selector '.current', text: 'トップ'
      end
      it '更新した投稿が、マイページの投稿一覧に表示されること' do
        click_button '更新する'
        visit  posts_user_path kenji
        expect(page).to have_content '投稿一覧 1 件'
        expect(page).to have_content '逆ソクラテス'
        expect(page).to have_css('.current', count: 1)
        expect(page).to have_selector '.current', text: '投稿一覧'
      end
      it '更新した情報が、投稿の詳細ページに表示されること' do
        click_button '更新する'
        visit posts_path
        click_link '逆ソクラテス'
        expect(page).to have_content '編集する'
        expect(page).to have_selector("img[src$='test_image.png']")
        expect(page).to have_content '逆ソクラテス'
        expect(page).to have_content '伊坂幸太郎'
        expect(page).to have_content '集英社'
        expect(page).to have_content '小説・文学'
        expect(page).to have_content '4'
        expect(page).to have_content '20〜30時間'
        expect(page).to have_content '2019-10-20'
        expect(page).to have_content '時間を忘れて読みました。'
        expect(page).to_not have_content '流浪の月'
        expect(page).to_not have_content '凪良ゆう'
      end
      it '更新した情報が、投稿編集ページに表示されること' do
        click_button '更新する'
        visit posts_path
        click_link '逆ソクラテス'
        click_link '編集する'
        expect(page).to have_selector("img[src$='test_image.png']")
        expect(page).to have_xpath "//input[@id='post_title'][@value='逆ソクラテス']"
        expect(page).to have_xpath "//input[@id='post_author'][@value='伊坂幸太郎']"
        expect(page).to have_xpath "//input[@id='post_publisher'][@value='集英社']"
        expect(page).to have_select('ジャンル', selected: '小説・文学')
        expect(page).to have_select('評価', selected: '4')
        expect(page).to have_select('読むのにかかった時間', selected: '20〜30時間')
        expect(page).to have_xpath "//input[@id='post_purchase_date'][@value='2019-10-20']"
        expect(page).to have_field '感想', with: '時間を忘れて読みました。'
      end
    end

    #  -----  無効な値  -----  #

    context '無効な値を入力する場合' do
      before do
        visit new_post_path
        fill_in 'post_title', with: '流浪の月'
        fill_in 'post_author', with: '凪良ゆう'
        click_button '投稿する'
        visit posts_path
        click_link '流浪の月'
        click_link '編集する'
      end
      it '値が空の場合、エラーメッセージが表示されること' do
        fill_in 'post_title', with: ''
        fill_in 'post_author', with: ''
        click_button '更新する'
        expect(page).to have_content '投稿 は保存されませんでした。'
        expect(page).to have_content 'タイトルを入力してください'
        expect(page).to have_content '著者を入力してください'
      end
      it 'タイトルが101文字以上の場合、エラーメッセージが表示されること' do
        char101 = 'a' * 101
        fill_in 'post_title', with: char101
        click_button '更新する'
        expect(page).to have_content '投稿 は保存されませんでした。'
        expect(page).to have_content 'タイトルは100文字以内で入力してください'
      end
      it '著者が61文字以上の場合、エラーメッセージが表示されること' do
        char61 = 'a' * 61
        fill_in 'post_author', with: char61
        click_button '更新する'
        expect(page).to have_content '投稿 は保存されませんでした。'
        expect(page).to have_content '著者は60文字以内で入力してください'
      end
      it '出版社が61文字以上の場合、エラーメッセージが表示されること' do
        char61 = 'a' * 61
        fill_in 'post_publisher', with: char61
        click_button '更新する'
        expect(page).to have_content '投稿 は保存されませんでした。'
        expect(page).to have_content '出版社は60文字以内で入力してください'
      end
      it '感想が1001文字以上の場合、エラーメッセージが表示されること' do
        char1001 = 'a' * 1001
        fill_in 'post_post_content', with: char1001
        click_button '更新する'
        expect(page).to have_content '投稿 は保存されませんでした。'
        expect(page).to have_content '感想は1000文字以内で入力してください'
      end
    end
  end

  describe 'ユーザはログインしなければ、投稿や投稿の編集をできない' do
    before do
      visit new_post_path
      fill_in 'post_title', with: '流浪の月'
      fill_in 'post_author', with: '凪良ゆう'
      click_button '投稿する'
      logout
    end
    it 'ログアウトすると、投稿ページが表示できず、エラーメッセージが表示されること' do
      visit new_post_path
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(current_path).to eq new_user_session_path
    end
    it 'ログアウトすると、投稿の詳細が表示できず、エラーメッセージが表示されること' do
      visit posts_path
      click_link '流浪の月'
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(current_path).to eq new_user_session_path
    end
    it 'ログアウトすると、投稿編集ページ表示できず、エラーメッセージが表示されること' do
      post = Post.last
      visit edit_post_path post
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(current_path).to eq new_user_session_path
    end
  end

  #--------------------#
  #        削除        #
  #--------------------#

  describe 'ユーザは投稿後、投稿を削除する', js: true do
    before do
      visit new_post_path
      fill_in 'post_title', with: '流浪の月'
      fill_in 'post_author', with: '凪良ゆう'
      click_button '投稿する'
      visit posts_path
      click_link '流浪の月'
      click_link '編集する'
    end
    it '削除される' do
      expect {
        click_link '投稿を削除する'
        page.driver.browser.switch_to.alert.accept
        wait_for_ajax
      }.to change { Post.count }.by(-1)
    end
    it '削除に成功したメッセージが表示されること' do
      click_link '投稿を削除する'
      page.driver.browser.switch_to.alert.accept
      wait_for_ajax
      expect(page).to have_content '投稿は削除されました。'
      expect(current_path).to eq user_path kenji
    end
    it '削除した投稿が本を探すの投稿一覧に表示されないこと' do
      click_link '投稿を削除する'
      page.driver.browser.switch_to.alert.accept
      wait_for_ajax
      visit posts_path
      expect(page).to_not have_content '流浪の月'
    end
    it '削除した投稿が、マイページの最新の投稿に表示されないこと' do
      click_link '投稿を削除する'
      page.driver.browser.switch_to.alert.accept
      wait_for_ajax
      visit user_path kenji
      expect(page).to_not have_content '逆ソクラテス'
      expect(page).to have_css('.current', count: 1)
      expect(page).to have_selector '.current', text: 'トップ'
    end
    it '削除した投稿が、マイページの投稿一覧に表示されないこと' do
      click_link '投稿を削除する'
      page.driver.browser.switch_to.alert.accept
      wait_for_ajax
      visit  posts_user_path kenji
      expect(page).to have_content '投稿一覧 0 件'
      expect(page).to_not have_content '逆ソクラテス'
      expect(page).to have_css('.current', count: 1)
      expect(page).to have_selector '.current', text: '投稿一覧'
    end
  end
end
