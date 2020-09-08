require 'rails_helper'

RSpec.feature 'Users', type: :system do

  let!(:kenji) { create(:kenji) }
  let!(:takashi) { create(:takashi) }
  let!(:michael) { create(:michael) }
  before do
    kenji.confirm
    takashi.confirm
    michael.confirm
  end

  scenario "ユーザ一覧を表示し、ログインユーザと他のユーザのマイページを確認する" do
    visit root_path
    expect(page).to have_http_status :ok

    click_link 'ユーザ一覧'
    expect(page).to have_content 'アカウント登録もしくはログインしてください。'
    expect(current_path).to eq new_user_session_path

    fill_in 'user_email', with: 'kenji@example.com'
    fill_in 'user_password', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'

    click_link 'ユーザ一覧'
    expect(page).to have_http_status :ok
    expect(page).to have_content 'けんじ'
    expect(page).to have_content 'たかし'
    expect(page).to have_content 'michael'

    #ログインしていないユーザのページを表示する
    click_link 'たかし'
    expect(page).to have_http_status :ok
    expect(page).to have_content 'たかし'
    expect(page).to_not have_content '編集'

    click_link 'ユーザ一覧'
    click_link 'michael'
    expect(page).to have_http_status :ok
    expect(page).to have_content 'michael'
    expect(page).to_not have_content '編集'

    click_link 'ユーザ一覧'
    click_link 'けんじ'
    expect(page).to have_http_status :ok
    expect(page).to have_content 'けんじ'
    expect(page).to have_content '編集'

  end
end