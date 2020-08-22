require 'rails_helper'

RSpec.feature 'Login', type: :system do
  background do
    ActionMailer::Base.deliveries.clear
  end


  scenario "ログインし、ユーザ情報を変更する" do
    FactoryBot.create(:kenji)
    kenji = User.last
    kenji.confirm

    visit root_path
    expect(page).to have_http_status :ok

    click_link 'ログイン'

    # -----ログインに失敗する場合-----

    #値が空の場合
    fill_in 'user_email', with: ''
    fill_in 'user_password', with: ''
    click_button 'ログイン'
    expect(page).to have_content 'メールアドレスまたはパスワードが違います。'

    #メールアドレスは正しいが、メールアドレスが正しくない場合
    fill_in 'user_email', with: 'kenij@example.com'
    fill_in 'user_password', with: 'abcdefgh'
    click_button 'ログイン'
    expect(page).to have_content 'メールアドレスまたはパスワードが違います。'

    #メールアドレスは正しくないが、メールアドレスが正しい場合
    fill_in 'user_email', with: 'abcdefgh@example.com'
    fill_in 'user_password', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content 'メールアドレスまたはパスワードが違います。'

    #-----ログインに成功する場合------
    fill_in 'user_email', with: 'kenji@example.com'
    fill_in 'user_password', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'

    click_link 'マイページ'
    expect(page).to have_http_status :ok
    expect(page).to have_content 'けんじ' 

    click_link '編集'
    expect(page).to have_http_status :ok
    expect(page).to have_content 'ユーザ情報編集'
    expect(page).to have_xpath"//input[@id='user_nickname'][@value='けんじ']"
    expect(page).to have_xpath"//input[@id='user_email'][@value='kenji@example.com']"

    #-----ユーザ情報を変更に失敗する場合-----
    #現在のパスワード空欄の場合
    click_button '変更する'
    expect(page).to have_content '現在のパスワードを入力してください'

    #現在のパスワードが正しくない場合
    fill_in 'user_nickname', with: 'new_kenji'
    fill_in 'user_current_password', with: 'invalidpassword'
    click_button'変更する'
    expect(page).to have_content '現在のパスワードは不正な値です'
    
    #ニックネームの値が51文字の場合
    char51 = 'a' * 51
    fill_in 'user_nickname', with: char51
    fill_in 'user_current_password', with: 'password'
    click_button'変更する'
    expect(page).to have_content 'ニックネームは50文字以内で入力してください'
    
    #メールアドレスが空欄の場合
    fill_in 'user_email', with: ''
    fill_in 'user_current_password', with: 'password'
    click_button'変更する'
    expect(page).to have_content 'メールアドレスが入力されていません'
    
    #パスワードが5文字以下の場合
    fill_in 'user_nickname', with: 'new_kenji'
    fill_in 'user_password', with: 'abcde'
    fill_in 'user_password_confirmation', with: 'abcde'
    fill_in 'user_current_password', with: 'password'
    click_button'変更する'
    expect(page).to have_content 'パスワードは6文字以上で入力してください'
    
    
    #-----ユーザ情報の変更に成功する場合-----
    #ユーザイメージ、ニックネーム、パスワードを変更する
    attach_file 'user_image', "spec/file/test_image.png"
    fill_in 'user_nickname', with: 'ミナカワけんじ'
    fill_in 'user_email', with: 'kenji@example.com'
    fill_in 'user_password', with: 'newpassword'
    fill_in 'user_password_confirmation', with: 'newpassword'
    fill_in 'user_current_password', with: 'password'
    click_button'変更する'
    expect(page).to have_content 'アカウント情報を変更しました。'
    expect(current_path).to eq root_path
    click_link 'マイページ'
    expect(page).to have_selector("img[src$='test_image.png']")
    expect(page).to have_content 'ミナカワけんじ'
    click_link '編集'
    expect(page).to have_selector("img[src$='test_image.png']")
    expect(page).to have_xpath"//input[@id='user_nickname'][@value='ミナカワけんじ']"

    #メールアドレスを変更する
    fill_in 'user_email', with: 'new_kenji@example.com'
    fill_in 'user_current_password', with: 'newpassword'
    expect { click_button '変更する' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(page).to have_content 'アカウント情報を変更しました。変更されたメールアドレスの本人確認のため、本人確認用メールより確認処理をおこなってください。'
    expect(current_path).to eq root_path

    user = User.find_by(nickname: 'ミナカワけんじ')
    token = user.confirmation_token
    visit user_confirmation_path(confirmation_token: token)
    expect(page).to have_content 'メールアドレスが確認できました。'
    expect(current_path).to eq root_path
    click_link 'マイページ'
    click_link '編集'
    expect(page).to have_xpath"//input[@id='user_email'][@value='new_kenji@example.com']"

    #ログアウトして新しい情報でログインする
    click_link 'ログアウト'
    expect(page).to have_content 'ログアウトしました。' 

    visit user_session_path
    fill_in 'user_email', with: 'new_kenji@example.com'
    fill_in 'user_password', with: 'newpassword'
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'

    click_link 'ログアウト'
    expect(page).to have_content 'ログアウトしました。' 

  end
end