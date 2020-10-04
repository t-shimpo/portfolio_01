require 'rails_helper'

RSpec.feature 'Posts_index', type: :system do
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
      end
      context '投稿一覧ページの場合' do
        it '投稿一覧ページに投稿が表示されている' do
          expect(page).to have_css('.post-container', count: 9)
          expect(page).to have_content '自分の中に毒を持て'
          expect(page).to have_content '火花'
          expect(page).to have_content '教育タイトル'
          expect(page).to have_content 'アートタイトル'
          expect(page).to have_content 'タレントタイトル'
          expect(page).to have_content '趣味タイトル'
          expect(page).to have_content '地理タイトル'
          expect(page).to have_content '子どもタイトル'
          expect(page).to have_content 'その他タイトル'
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: '投稿一覧'
          expect(page).to have_selector '.current-genre', text: '全て表示'
        end
        it '投稿一覧(小説・文学)ページに投稿が表示されている' do
          click_link '小説'
          expect(page).to have_css('.post-container', count: 1)
          expect(page).to have_content '火花'
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: '投稿一覧'
          expect(page).to have_selector '.current-genre', text: '小説'
        end
        it '投稿一覧(自己啓発・ビジネス)ページに投稿が表示されている' do
          click_link 'ビジネス'
          expect(page).to have_css('.post-container', count: 1)
          expect(page).to have_content '自分の中に毒を持て'
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: '投稿一覧'
          expect(page).to have_selector '.current-genre', text: 'ビジネス'
        end
        it '投稿一覧(教育・教養)ページに投稿が表示されている' do
          click_link '教育'
          expect(page).to have_css('.post-container', count: 1)
          expect(page).to have_content '教育タイトル'
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: '投稿一覧'
          expect(page).to have_selector '.current-genre', text: '教育'
        end
        it '投稿一覧(アート・エンタメ)ページに投稿が表示されている' do
          click_link 'エンタメ'
          expect(page).to have_css('.post-container', count: 1)
          expect(page).to have_content 'アートタイトル'
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: '投稿一覧'
          expect(page).to have_selector '.current-genre', text: 'エンタメ'
        end
        it '投稿一覧(タレント本)ページに投稿が表示されている' do
          click_link 'タレント'
          expect(page).to have_css('.post-container', count: 1)
          expect(page).to have_content 'タレントタイトル'
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: '投稿一覧'
          expect(page).to have_selector '.current-genre', text: 'タレント'
        end
        it '投稿一覧(趣味)ページに投稿が表示されている' do
          click_link '趣味'
          expect(page).to have_css('.post-container', count: 1)
          expect(page).to have_content '趣味タイトル'
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: '投稿一覧'
          expect(page).to have_selector '.current-genre', text: '趣味'
        end
        it '投稿一覧(旅行・地理)ページに投稿が表示されている' do
          click_link '旅行地理'
          expect(page).to have_css('.post-container', count: 1)
          expect(page).to have_content '地理タイトル'
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: '投稿一覧'
          expect(page).to have_selector '.current-genre', text: '旅行地理'
        end
        it '投稿一覧(こども向け)ページに投稿が表示されている' do
          click_link '子ども'
          expect(page).to have_css('.post-container', count: 1)
          expect(page).to have_content '子どもタイトル'
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: '投稿一覧'
          expect(page).to have_selector '.current-genre', text: '子ども'
        end
        it '投稿一覧(その他)ページに投稿が表示されている' do
          click_link 'その他'
          expect(page).to have_css('.post-container', count: 1)
          expect(page).to have_content 'その他タイトル'
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: '投稿一覧'
          expect(page).to have_selector '.current-genre', text: 'その他'
        end
      end
      context 'フォローユーザの投稿の場合' do
        before { click_link 'フォローユーザの投稿' }
        it 'フォローユーザの投稿ページに投稿が表示されていないこと' do
          expect(page).to have_css('.post-container', count: 0)
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
          expect(page).to have_selector '.current-genre', text: '全て表示'
        end
        it 'フォローユーザの投稿(小説・文学)ページに投稿が表示されていないこと' do
          click_link '小説'
          expect(page).to have_css('.post-container', count: 0)
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
          expect(page).to have_selector '.current-genre', text: '小説'
        end
        it 'フォローユーザの投稿(自己啓発・ビジネス)ページに投稿が表示されていないこと' do
          click_link 'ビジネス'
          expect(page).to have_css('.post-container', count: 0)
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
          expect(page).to have_selector '.current-genre', text: 'ビジネス'
        end
        it 'フォローユーザの投稿(教育・教養)ページに投稿が表示されていないこと' do
          click_link '教育'
          expect(page).to have_css('.post-container', count: 0)
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
          expect(page).to have_selector '.current-genre', text: '教育'
        end
        it 'フォローユーザの投稿(アート・エンタメ)ページに投稿が表示されていないこと' do
          click_link 'エンタメ'
          expect(page).to have_css('.post-container', count: 0)
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
          expect(page).to have_selector '.current-genre', text: 'エンタメ'
        end
        it 'フォローユーザの投稿(タレント本)ページに投稿が表示されていないこと' do
          click_link 'タレント'
          expect(page).to have_css('.post-container', count: 0)
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
          expect(page).to have_selector '.current-genre', text: 'タレント'
        end
        it 'フォローユーザの投稿(趣味)ページに投稿が表示されていないこと' do
          click_link '趣味'
          expect(page).to have_css('.post-container', count: 0)
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
          expect(page).to have_selector '.current-genre', text: '趣味'
        end
        it 'フォローユーザの投稿(旅行・地理)ページに投稿が表示されていないこと' do
          click_link '旅行地理'
          expect(page).to have_css('.post-container', count: 0)
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
          expect(page).to have_selector '.current-genre', text: '旅行地理'
        end
        it 'フォローユーザの投稿(こども向け)ページに投稿が表示されていないこと' do
          click_link '子ども'
          expect(page).to have_css('.post-container', count: 0)
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
          expect(page).to have_selector '.current-genre', text: '子ども'
        end
        it 'フォローユーザの投稿(その他)ページに投稿が表示されていないこと' do
          click_link 'その他'
          expect(page).to have_css('.post-container', count: 0)
          expect(page).to have_css('.current-tab', count: 1)
          expect(page).to have_css('.current-genre', count: 1)
          expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
          expect(page).to have_selector '.current-genre', text: 'その他'
        end
      end
    end
    context 'フォロー後' do
      # michaelでログインし、たかしをフォローする
      before do
        login michael
        Relationship.create(follower_id: michael.id, following_id: takashi.id)
        click_link '本を探す'
        click_link 'フォローユーザの投稿'
      end
      it 'フォローユーザの投稿ページに投稿が表示されていること' do
        expect(page).to have_css('.post-container', count: 9)
        expect(page).to have_content '自分の中に毒を持て'
        expect(page).to have_content '火花'
        expect(page).to have_content '教育タイトル'
        expect(page).to have_content 'アートタイトル'
        expect(page).to have_content 'タレントタイトル'
        expect(page).to have_content '趣味タイトル'
        expect(page).to have_content '地理タイトル'
        expect(page).to have_content '子どもタイトル'
        expect(page).to have_content 'その他タイトル'
        expect(page).to have_css('.current-tab', count: 1)
        expect(page).to have_css('.current-genre', count: 1)
        expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
        expect(page).to have_selector '.current-genre', text: '全て表示'
      end
      it 'フォローユーザの投稿(小説・文学)ページに投稿が表示されていること' do
        click_link '小説'
        expect(page).to have_css('.post-container', count: 1)
        expect(page).to have_content '火花'
        expect(page).to have_css('.current-tab', count: 1)
        expect(page).to have_css('.current-genre', count: 1)
        expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
        expect(page).to have_selector '.current-genre', text: '小説'
      end
      it 'フォローユーザの投稿(自己啓発・ビジネス)ページに投稿が表示されていること' do
        click_link 'ビジネス'
        expect(page).to have_css('.post-container', count: 1)
        expect(page).to have_content '自分の中に毒を持て'
        expect(page).to have_css('.current-tab', count: 1)
        expect(page).to have_css('.current-genre', count: 1)
        expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
        expect(page).to have_selector '.current-genre', text: 'ビジネス'
      end
      it 'フォローユーザの投稿(教育・教養)ページに投稿が表示されていること' do
        click_link '教育'
        expect(page).to have_css('.post-container', count: 1)
        expect(page).to have_content '教育タイトル'
        expect(page).to have_css('.current-tab', count: 1)
        expect(page).to have_css('.current-genre', count: 1)
        expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
        expect(page).to have_selector '.current-genre', text: '教育'
      end
      it 'フォローユーザの投稿(アート・エンタメ)ページに投稿が表示されていること' do
        click_link 'エンタメ'
        expect(page).to have_css('.post-container', count: 1)
        expect(page).to have_content 'アートタイトル'
        expect(page).to have_css('.current-tab', count: 1)
        expect(page).to have_css('.current-genre', count: 1)
        expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
        expect(page).to have_selector '.current-genre', text: 'エンタメ'
      end
      it 'フォローユーザの投稿(タレント本)ページに投稿が表示されていること' do
        click_link 'タレント'
        expect(page).to have_css('.post-container', count: 1)
        expect(page).to have_content 'タレントタイトル'
        expect(page).to have_css('.current-tab', count: 1)
        expect(page).to have_css('.current-genre', count: 1)
        expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
        expect(page).to have_selector '.current-genre', text: 'タレント'
      end
      it 'フォローユーザの投稿(趣味)ページに投稿が表示されていること' do
        click_link '趣味'
        expect(page).to have_css('.post-container', count: 1)
        expect(page).to have_content '趣味タイトル'
        expect(page).to have_css('.current-tab', count: 1)
        expect(page).to have_css('.current-genre', count: 1)
        expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
        expect(page).to have_selector '.current-genre', text: '趣味'
      end
      it 'フォローユーザの投稿(旅行・地理)ページに投稿が表示されていること' do
        click_link '旅行地理'
        expect(page).to have_css('.post-container', count: 1)
        expect(page).to have_content '地理タイトル'
        expect(page).to have_css('.current-tab', count: 1)
        expect(page).to have_css('.current-genre', count: 1)
        expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
        expect(page).to have_selector '.current-genre', text: '旅行地理'
      end
      it 'フォローユーザの投稿(こども向け)ページに投稿が表示されていること' do
        click_link '子ども'
        expect(page).to have_css('.post-container', count: 1)
        expect(page).to have_content '子どもタイトル'
        expect(page).to have_css('.current-tab', count: 1)
        expect(page).to have_css('.current-genre', count: 1)
        expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
        expect(page).to have_selector '.current-genre', text: '子ども'
      end
      it 'フォローユーザの投稿(その他)ページに投稿が表示されていること' do
        click_link 'その他'
        expect(page).to have_css('.post-container', count: 1)
        expect(page).to have_content 'その他タイトル'
        expect(page).to have_css('.current-tab', count: 1)
        expect(page).to have_css('.current-genre', count: 1)
        expect(page).to have_selector '.current-tab', text: 'フォローユーザの投稿'
        expect(page).to have_selector '.current-genre', text: 'その他'
      end
    end
  end
end
