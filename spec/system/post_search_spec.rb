require 'rails_helper'

RSpec.feature 'PostSearch', type: :system  do

  let!(:post1) { create(:post, title: '投稿タイトル', genre: 'novel') }
  let!(:post2) { create(:post, title: 'ポスト', author: 'ユーザ', genre: 'novel') }
  let!(:post3) { create(:post, title: '著書', publisher: '出版社', genre: 'novel') }
  let!(:post4) { create(:post, title: '投稿タイトル', genre: 'business') }
  let!(:post5) { create(:post, title: 'ポスト', author: 'ユーザ', genre: 'business') }
  let!(:post6) { create(:post, title: '著書', publisher: '出版社', genre: 'business') }
  let!(:post7) { create(:post, title: '投稿タイトル', genre: 'education') }
  let!(:post8) { create(:post, title: 'ポスト', author: 'ユーザ', genre: 'education') }
  let!(:post9) { create(:post, title: '著書', publisher: '出版社', genre: 'education') }
  let!(:post10) { create(:post, title: '投稿タイトル', genre: 'art_ent') }
  let!(:post11) { create(:post, title: 'ポスト', author: 'ユーザ', genre: 'art_ent') }
  let!(:post12) { create(:post, title: '著書', publisher: '出版社', genre: 'art_ent') }
  let!(:post13) { create(:post, title: '投稿タイトル', genre: 'celebrity') }
  let!(:post14) { create(:post, title: 'ポスト', author: 'ユーザ', genre: 'celebrity') }
  let!(:post15) { create(:post, title: '著書', publisher: '出版社', genre: 'celebrity') }
  let!(:post16) { create(:post, title: '投稿タイトル', genre: 'hobby') }
  let!(:post17) { create(:post, title: 'ポスト', author: 'ユーザ', genre: 'hobby') }
  let!(:post18) { create(:post, title: '著書', publisher: '出版社', genre: 'hobby') }
  let!(:post19) { create(:post, title: '投稿タイトル', genre: 'geography') }
  let!(:post20) { create(:post, title: 'ポスト', author: 'ユーザ', genre: 'geography') }
  let!(:post21) { create(:post, title: '著書', publisher: '出版社', genre: 'geography') }
  let!(:post22) { create(:post, title: '投稿タイトル', genre: 'child') }
  let!(:post23) { create(:post, title: 'ポスト', author: 'ユーザ', genre: 'child') }
  let!(:post24) { create(:post, title: '著書', publisher: '出版社', genre: 'child') }
  let!(:post25) { create(:post, title: '投稿タイトル', genre: 'others') }
  let!(:post26) { create(:post, title: 'ポスト', author: 'ユーザ', genre: 'others') }
  let!(:post27) { create(:post, title: '著書', publisher: '出版社', genre: 'others') }

  describe '投稿を検索する' do
    context 'ジャンル：全て表示の場合' do
      before { visit posts_path }
      it '投稿名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 16)
        expect(page).to have_content '投稿タイトル'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'タイトル'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 9)
        expect(page).to have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '著者名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 16)
        expect(page).to have_content '投稿タイトル'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'ユーザ'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 9)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '出版社名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 16)
        expect(page).to have_content '投稿タイトル'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: '出版'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 9)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to have_content '著書'
      end
    end
    context 'ジャンル：小説の場合' do
      before { visit novel_posts_path }
      it '投稿名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'タイトル'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '著者名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'ユーザ'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '出版社名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: '出版'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to have_content '著書'
      end
    end
    context 'ジャンル：ビジネスの場合' do
      before { visit business_posts_path }
      it '投稿名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'タイトル'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '著者名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'ユーザ'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '出版社名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: '出版'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to have_content '著書'
      end
    end
    context 'ジャンル：教育の場合' do
      before { visit education_posts_path }
      it '投稿名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'タイトル'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '著者名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'ユーザ'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '出版社名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: '出版'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to have_content '著書'
      end
    end
    context 'ジャンル：エンタメの場合' do
      before { visit art_ent_posts_path }
      it '投稿名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'タイトル'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '著者名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'ユーザ'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '出版社名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: '出版'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to have_content '著書'
      end
    end
    context 'ジャンル：タレント本の場合' do
      before { visit celebrity_posts_path }
      it '投稿名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'タイトル'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '著者名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'ユーザ'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '出版社名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: '出版'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to have_content '著書'
      end
    end
    context 'ジャンル：趣味の場合' do
      before { visit hobby_posts_path }
      it '投稿名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'タイトル'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '著者名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'ユーザ'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '出版社名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: '出版'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to have_content '著書'
      end
    end
    context 'ジャンル：旅行・地理の場合' do
      before { visit geography_posts_path }
      it '投稿名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'タイトル'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '著者名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'ユーザ'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '出版社名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: '出版'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to have_content '著書'
      end
    end
    context 'ジャンル：子どもの場合' do
      before { visit child_posts_path }
      it '投稿名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'タイトル'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '著者名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'ユーザ'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '出版社名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: '出版'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to have_content '著書'
      end
    end
    context 'ジャンル：その他の場合' do
      before { visit others_posts_path }
      it '投稿名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'タイトル'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '著者名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: 'ユーザ'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to have_content 'ポスト'
        expect(page).to_not have_content '著書'
      end
      it '出版社名が一致した投稿が表示される' do
        expect(page).to have_css('.post-container',count: 3)
        expect(page).to have_content '投稿'
        expect(page).to have_content 'ポスト'
        expect(page).to have_content '著書'
        fill_in 'search', with: '出版'
        click_button '検索'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to_not have_content '投稿タイトル'
        expect(page).to_not have_content 'ポスト'
        expect(page).to have_content '著書'
      end
    end
  end
end