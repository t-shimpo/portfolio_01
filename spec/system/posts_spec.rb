require 'rails_helper'

RSpec.feature 'Posts', type: :system do

  let!(:kenji) { create(:kenji) }
  before do
    kenji.confirm
    login kenji
  end 

  describe "ユーザは投稿する" do
    context "有効な値を入力する場合" do
      before do
        visit new_post_path
        attach_file 'post_post_image', "spec/file/test_image.png"
        fill_in 'post_title', with: '流浪の月'
        fill_in 'post_author', with: '凪良ゆう'
        fill_in 'post_publisher', with: '東京創元社'
        select '小説・文学', from: 'ジャンル'
        select '3.5', from: '評価（1~5）'
        select '30〜40時間', from: '読むのにかかった時間'
        fill_in 'post_purchase_date', with: '2019-2-21'
        fill_in 'post_post_content', with: '正しい生き方は何か、考えさせられました。'
        click_button '投稿する'
      end
      it "投稿が成功したメッセージが表示される" do
        expect(page).to have_content '投稿されました。'
        expect(current_path).to eq new_post_path
      end
      it "投稿が、投稿一覧に表示される" do
        visit posts_path
        expect(page).to have_content '流浪の月' 
        expect(page).to have_content 'けんじ' 
      end
      it "投稿した情報が、投稿の詳細ページに表示される" do
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
      it "投稿した情報が、投稿編集ページに表示される" do
        visit posts_path
        click_link '流浪の月' 
        click_link '編集する'
        expect(page).to have_selector("img[src$='test_image.png']")
        expect(page).to have_xpath"//input[@id='post_title'][@value='流浪の月']"
        expect(page).to have_xpath"//input[@id='post_author'][@value='凪良ゆう']"
        expect(page).to have_xpath"//input[@id='post_publisher'][@value='東京創元社']"
        expect(page).to have_select('ジャンル', selected: '小説・文学')
        expect(page).to have_select('評価', selected: '3.5')
        expect(page).to have_select('読むのにかかった時間', selected: '30〜40時間')
        expect(page).to have_xpath"//input[@id='post_purchase_date'][@value='2019-02-21']"
        expect(page).to have_field '感想', with: '正しい生き方は何か、考えさせられました。'
      end
    end

    context '無効な値を入力する場合' do
      before do
        visit new_post_path
        fill_in 'post_title', with: ''
        fill_in 'post_author', with: ''
        fill_in 'post_publisher', with: '東京創元社'
        click_button '投稿する'
      end
      it "エラーメッセージが表示される" do
        expect(page).to have_content '2件のエラーが発生したため投稿は保存されませんでした。'
        expect(page).to have_content 'タイトルを入力してください'
        expect(page).to have_content '著者を入力してください'
        expect(page).to have_xpath"//input[@id='post_publisher'][@value='東京創元社']"
      end
      it "投稿に失敗し、投稿一覧に表示されない" do
        visit posts_path
        expect(page).to_not have_content '流浪の月' 
        expect(page).to_not have_content 'けんじ' 
      end
    end
  end

  describe "ユーザは投稿後、投稿を更新する" do
    context "有効な値を入力する場合" do
      before do
        visit new_post_path
        fill_in 'post_title', with: '流浪の月'
        fill_in 'post_author', with: '凪良ゆう'
        click_button '投稿する'
        visit posts_path
        click_link '流浪の月' 
        click_link '編集する'
        attach_file 'post_post_image', "spec/file/test_image.png"
        fill_in 'post_title', with: '逆ソクラテス'
        fill_in 'post_author', with: '伊坂幸太郎'
        fill_in 'post_publisher', with: '集英社'
        select '小説・文学', from: 'ジャンル'
        select '4', from: '評価（1~5）'
        select '20〜30時間', from: '読むのにかかった時間'
        fill_in 'post_purchase_date', with: '2019-10-20'
        fill_in 'post_post_content', with: '時間を忘れて読みました。'
        click_button '更新する'
      end
      it "更新が成功したメッセージが表示される" do
        expect(page).to have_content '投稿は更新されました。'
        expect(current_path).to eq post_path kenji.posts.last
      end
      it "更新したタイトルが投稿一覧に表示される" do
        visit posts_path
        expect(page).to have_content '逆ソクラテス' 
        expect(page).to_not have_content '流浪の月' 
        expect(page).to have_content 'けんじ' 
      end
      it "更新した情報が、投稿の詳細ページに表示される" do
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
      it "更新した情報が、投稿編集ページに表示される" do
        visit posts_path
        click_link '逆ソクラテス' 
        click_link '編集する'
        expect(page).to have_selector("img[src$='test_image.png']")
        expect(page).to have_xpath"//input[@id='post_title'][@value='逆ソクラテス']"
        expect(page).to have_xpath"//input[@id='post_author'][@value='伊坂幸太郎']"
        expect(page).to have_xpath"//input[@id='post_publisher'][@value='集英社']"
        expect(page).to have_select('ジャンル', selected: '小説・文学')
        expect(page).to have_select('評価', selected: '4')
        expect(page).to have_select('読むのにかかった時間', selected: '20〜30時間')
        expect(page).to have_xpath"//input[@id='post_purchase_date'][@value='2019-10-20']"
        expect(page).to have_field '感想', with: '時間を忘れて読みました。'
      end
    end

    context "無効な値を入力する場合" do
      before do
        visit new_post_path
        fill_in 'post_title', with: '流浪の月'
        fill_in 'post_author', with: '凪良ゆう'
        click_button '投稿する'
        visit posts_path
        click_link '流浪の月' 
        click_link '編集する'
        fill_in 'post_title', with: ''
        fill_in 'post_author', with: ''
        click_button '更新する'
      end
      it "エラーメッセージが表示される" do
        expect(page).to have_content '2件のエラーが発生したため投稿は保存されませんでした。'
        expect(page).to have_content 'タイトルを入力してください'
        expect(page).to have_content '著者を入力してください'
      end
      it " 更新に失敗し、投稿一覧の情報も更新されない" do
        visit posts_path
        expect(page).to have_content '流浪の月' 
        expect(page).to have_content 'けんじ' 
      end
    end
  end

  describe "ユーザは投稿後、投稿を削除する", js: true do
    before do
      visit new_post_path
        fill_in 'post_title', with: '流浪の月'
        fill_in 'post_author', with: '凪良ゆう'
        click_button '投稿する'
        visit posts_path
        click_link '流浪の月' 
        click_link '編集する'
        click_link '投稿を削除する'
        page.driver.browser.switch_to.alert.accept
    end
    it "削除に成功したメッセージが表示される" do
      expect(page).to have_content '投稿は削除されました。'
      expect(current_path).to eq user_path kenji
    end
    it "削除した投稿が投稿一覧に表示されていない" do
      visit posts_path
      expect(page).to_not have_content '流浪の月' 
      expect(page).to_not have_content 'けんじ' 
    end
  end

end