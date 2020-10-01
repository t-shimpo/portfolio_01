require 'rails_helper'

RSpec.feature 'UserSearch', type: :system  do
  let!(:michael) { create(:michael) }
  let!(:takashi) { create(:takashi) }
  let!(:kenji) { create(:kenji) }
  before do
    michael.confirm
    takashi.confirm
    kenji.confirm
  end

  describe 'ユーザを検索する' do
    before { visit users_path }
    it 'ユーザ名が完全に一致したユーザが表示される' do
      expect(page).to have_css('.user-container',count: 3)
      expect(page).to have_content 'たかし'
      expect(page).to have_content 'michael'
      fill_in 'search', with: 'たかし'
      click_button '検索'
      expect(page).to have_css('.user-container',count: 1)
      expect(page).to have_content 'たかし'
      expect(page).to_not have_content 'michael'
    end
    it 'ユーザ名が前方一致したユーザが表示される' do
      expect(page).to have_css('.user-container',count: 3)
      expect(page).to have_content 'たかし'
      expect(page).to have_content 'michael'
      fill_in 'search', with: 'た'
      click_button '検索'
      expect(page).to have_css('.user-container',count: 1)
      expect(page).to have_content 'たかし'
      expect(page).to_not have_content 'michael'
    end
    it 'ユーザ名が後方一致したユーザが表示される' do
      expect(page).to have_css('.user-container',count: 3)
      expect(page).to have_content 'たかし'
      expect(page).to have_content 'michael'
      fill_in 'search', with: 'かし'
      click_button '検索'
      expect(page).to have_css('.user-container',count: 1)
      expect(page).to have_content 'たかし'
      expect(page).to_not have_content 'michael'
    end
    it 'ユーザ名の一部が一致したユーザが表示される' do
      expect(page).to have_css('.user-container',count: 3)
      expect(page).to have_content 'たかし'
      expect(page).to have_content 'michael'
      fill_in 'search', with: 'か'
      click_button '検索'
      expect(page).to have_css('.user-container',count: 1)
      expect(page).to have_content 'たかし'
      expect(page).to_not have_content 'michael'
    end
  end
end