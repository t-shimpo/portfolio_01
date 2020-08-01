require 'rails_helper'

RSpec.describe "UserSession", type: :request do

  let(:user) { create(:user) }
  let(:user_params) { attributes_for(:user) }

  context 'パラメータが正しい場合' do
    before do
      user.confirm
      visit login_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_button 'ログイン'
    end
    it 'ログインが成功し、ヘッダーが変わること' do
      expect(page).to have_content 'ログインしました。'
      expect(page).to_not have_css('a', text: "ログイン")
      expect(page).to have_css('a', text: "マイページ")
      expect(page).to have_css('a', text: "ログアウト")
    end
  end

  context 'パラメータが不正の場合' do
    before do
      user.confirm
      visit login_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'aaaaaa'
      click_button 'ログイン'
    end
    it 'ログインが失敗し、ヘッダーが変わらないこと' do
      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      expect(page).to have_css('a', text: "ログイン")
      expect(page).to_not have_css('a', text: "マイページ")
      expect(page).to_not have_css('a', text: "ログアウト")
    end
  end
end