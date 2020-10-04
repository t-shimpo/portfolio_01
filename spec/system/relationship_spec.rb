require 'rails_helper'

RSpec.feature 'Relationship', type: :system, js: true, retry: 3 do
  let!(:takashi) { create(:takashi) }
  let!(:michael) { create(:michael) }
  before do
    takashi.confirm
    michael.confirm
  end
  let!(:jibun_nonakani_doku) { create(:jibun_nonakani_doku, user_id: takashi.id) }

  describe 'ユーザは他のユーザをフォローする' do
    before do
      login michael
      visit user_path takashi
    end
    # michaelがたかしをフォローする
    it 'フォローが成功すること' do
      expect {
        click_button 'フォローする'
        wait_for_ajax
      }.to change { takashi.followers.count }.by(1)
      expect(michael.following.count).to eq 1
      expect(page).to have_xpath "//input[@value='フォロー中']"
    end
    it 'ユーザ詳細ページのフォロワー数の表示が変わること' do
      expect(page).to have_content 'フォロワー 0'
      click_button 'フォローする'
      wait_for_ajax
      expect(page).to have_content 'フォロワー 1'
    end
    it 'マイページのフォロー数の表示が変わること' do
      visit user_path michael
      expect(page).to have_content 'フォロー 0'
      visit user_path takashi
      click_button 'フォローする'
      wait_for_ajax
      visit user_path michael
      expect(page).to have_content 'フォロー 1'
    end
    it 'ユーザ一覧ページのフォロー・フォロワー数の表示が変わること' do
      click_button 'フォローする'
      wait_for_ajax
      visit users_path
      expect(page).to have_content 'フォロー 1 フォロワー 0'
      expect(page).to have_content 'フォロー 0 フォロワー 1'
    end
    it 'michaelのフォロー一覧に、たかしが表示されること' do
      click_button 'フォローする'
      wait_for_ajax
      visit user_path michael
      click_link 'フォロー'
      expect(page).to have_content 'フォロー 1 人'
      expect(page).to have_content 'たかし'
      expect(page).to have_css('.current', count: 1)
      expect(page).to have_selector '.current', text: 'フォロー'
    end
    it 'たかしのフォロー一覧に、michaelが表示されること' do
      click_button 'フォローする'
      wait_for_ajax
      visit user_path takashi
      click_link 'フォロワー'
      expect(page).to have_content 'フォロワー 1 人'
      expect(page).to have_content 'michael'
      expect(page).to have_css('.current', count: 1)
      expect(page).to have_selector '.current', text: 'フォロワー'
    end
  end

  describe 'ユーザは他のユーザのフォローを解除する' do
    # michaelが予め,たかしをフォローする
    before do
      login michael
      visit user_path takashi
      click_button 'フォローする'
      wait_for_ajax
    end
    # michaelがたかしをフォローを解除する
    it 'フォロー解除が成功すること' do
      expect {
        click_button 'フォロー中'
        wait_for_ajax
      }.to change { takashi.followers.count }.by(-1)
      expect(michael.following.count).to eq 0
      expect(page).to have_xpath "//input[@value='フォローする']"
    end
    it 'ユーザ詳細ページのフォロー・フォロワー数の表示が変わること' do
      expect(page).to have_content 'フォロワー 1'
      click_button 'フォロー中'
      wait_for_ajax
      expect(page).to have_content 'フォロワー 0'
    end
    it 'マイページのフォロー数の表示が変わること' do
      visit user_path michael
      expect(page).to have_content 'フォロー 1'
      visit user_path takashi
      click_button 'フォロー中'
      wait_for_ajax
      visit user_path michael
      expect(page).to have_content 'フォロー 0'
    end
    it 'ユーザ一覧ページのフォロワー数の表示が変わること' do
      click_button 'フォロー中'
      wait_for_ajax
      visit users_path
      expect(page).to have_content 'フォロー 0 フォロワー 0'
      expect(page).to have_content 'フォロー 0 フォロワー 0'
    end
    it 'michaelのフォロー一覧に、たかしが表示されないこと' do
      click_button 'フォロー中'
      wait_for_ajax
      visit user_path michael
      click_link 'フォロー'
      expect(page).to have_content 'フォロー 0 人'
      expect(page).to_not have_content 'たかし'
      expect(page).to have_css('.current', count: 1)
      expect(page).to have_selector '.current', text: 'フォロー'
    end
    it 'たかしのフォロー一覧に、michaelが表示されないこと' do
      click_button 'フォロー中'
      wait_for_ajax
      visit user_path takashi
      click_link 'フォロワー'
      expect(page).to have_content 'フォロワー 0 人'
      expect(page).to_not have_content 'michael'
      expect(page).to have_css('.current', count: 1)
      expect(page).to have_selector '.current', text: 'フォロワー'
    end
  end
end
