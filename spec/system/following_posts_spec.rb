require 'rails_helper'

RSpec.feature 'FollowingPosts', type: :system, js: true do
  let!(:takashi) { create(:takashi) }
  let!(:michael) { create(:michael) }
  let!(:user) { create(:user) }
  before do
    takashi.confirm
    michael.confirm
  end
  let!(:jibun_nonakani_doku) { create(:jibun_nonakani_doku, user_id: takashi.id) }
  let!(:hibana) { create(:hibana, user_id: takashi.id) }
  let!(:education) { create(:post, title: '教育タイトル', genre: 'education', user_id: takashi.id) }
  let!(:art_ent) { create(:post, title: 'アートタイトル', genre: 'art_ent', user_id: takashi.id) }
  let!(:celebrity) { create(:post, title: 'タレントタイトル', genre: 'celebrity', user_id: takashi.id) }
  let!(:hobby) { create(:post, title: '趣味タイトル', genre: 'hobby', user_id: takashi.id) }
  let!(:geography) { create(:post, title: '地理タイトル', genre: 'geography', user_id: takashi.id) }
  let!(:child) { create(:post, title: '子どもタイトル', genre: 'child', user_id: takashi.id) }
  let!(:others) { create(:post, title: 'その他タイトル', genre: 'others', user_id: takashi.id) }

  describe 'フォローしたユーザの投稿がフォローユーザの投稿の各ページに表示される' do
    context 'フォロー前' do
      # michaelでログインする
      before do
        login michael
        click_link '本を探す'
        click_link 'フォローユーザの投稿'
      end
      it 'フォローユーザの投稿ページに投稿が表示されていないこと' do
        expect(page).to have_css('.post-container',count: 0)
      end
      it 'フォローユーザの投稿(小説・文学)ページに投稿が表示されていないこと' do
        click_link '小説'
        expect(page).to have_css('.post-container',count: 0)
      end
      it 'フォローユーザの投稿(自己啓発・ビジネス)ページに投稿が表示されていないこと' do
        click_link 'ビジネス'
        expect(page).to have_css('.post-container',count: 0)
      end
      it 'フォローユーザの投稿(教育・教養)ページに投稿が表示されていないこと' do
        click_link '教育'
        expect(page).to have_css('.post-container',count: 0)
      end
      it 'フォローユーザの投稿(アート・エンタメ)ページに投稿が表示されていないこと' do
        click_link 'エンタメ'
        expect(page).to have_css('.post-container',count: 0)
      end
      it 'フォローユーザの投稿(タレント本)ページに投稿が表示されていないこと' do
        click_link 'タレント本'
        expect(page).to have_css('.post-container',count: 0)
      end
      it 'フォローユーザの投稿(趣味)ページに投稿が表示されていないこと' do
        click_link '趣味'
        expect(page).to have_css('.post-container',count: 0)
      end
      it 'フォローユーザの投稿(旅行・地理)ページに投稿が表示されていないこと' do
        click_link '旅行・地理'
        expect(page).to have_css('.post-container',count: 0)
      end
      it 'フォローユーザの投稿(こども向け)ページに投稿が表示されていないこと' do
        click_link '子ども'
        expect(page).to have_css('.post-container',count: 0)
      end
      it 'フォローユーザの投稿(その他)ページに投稿が表示されていないこと' do
        click_link 'その他'
        expect(page).to have_css('.post-container',count: 0)
      end
    end
    context 'フォロー後' do
      # michaelでログインし、たかしをフォローする
      before do
        login michael
        visit user_path takashi
        click_button 'フォローする'
        click_link '本を探す'
        click_link 'フォローユーザの投稿'
      end
      it 'フォローユーザの投稿ページに投稿が表示されていること' do
        expect(page).to have_css('.post-container',count: 9)
        expect(page).to have_content '自分の中に毒を持て'
        expect(page).to have_content '火花'
        expect(page).to have_content '教育タイトル'
        expect(page).to have_content 'アートタイトル'
        expect(page).to have_content 'タレントタイトル'
        expect(page).to have_content '趣味タイトル'
        expect(page).to have_content '地理タイトル'
        expect(page).to have_content '子どもタイトル'
        expect(page).to have_content 'その他タイトル'
      end
      it 'フォローユーザの投稿(小説・文学)ページに投稿が表示されていること' do
        click_link '小説'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '火花'
      end
      it 'フォローユーザの投稿(自己啓発・ビジネス)ページに投稿が表示されていること' do
        click_link 'ビジネス'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '自分の中に毒を持て'
      end
      it 'フォローユーザの投稿(教育・教養)ページに投稿が表示されていること' do
        click_link '教育'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '教育タイトル'
      end
      it 'フォローユーザの投稿(アート・エンタメ)ページに投稿が表示されていること' do
        click_link 'エンタメ'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content 'アートタイトル'
      end
      it 'フォローユーザの投稿(タレント本)ページに投稿が表示されていること' do
        click_link 'タレント本'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content 'タレントタイトル'
      end
      it 'フォローユーザの投稿(趣味)ページに投稿が表示されていること' do
        click_link '趣味'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '趣味タイトル'
      end
      it 'フォローユーザの投稿(旅行・地理)ページに投稿が表示されていること' do
        click_link '旅行・地理'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '地理タイトル'
      end
      it 'フォローユーザの投稿(こども向け)ページに投稿が表示されていること' do
        click_link '子ども'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content '子どもタイトル'
      end
      it 'フォローユーザの投稿(その他)ページに投稿が表示されていること' do
        click_link 'その他'
        expect(page).to have_css('.post-container',count: 1)
        expect(page).to have_content 'その他タイトル'
      end
    end
  end

end