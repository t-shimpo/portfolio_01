require 'rails_helper'

RSpec.feature 'Sign up', type: :system do
  background do
    ActionMailer::Base.deliveries.clear
  end

  scenario "新規会員登録をし、そのユーザでログインする" do
    visit root_path
    expect(page).to have_http_status :ok

    click_link '新規登録'

    # -----登録に失敗する場合-----
    #値が空の場合
    click_button '新規登録'
    expect(page).to have_content 'ニックネームが入力されていません'
    expect(page).to have_content 'メールアドレスが入力されていません'
    expect(page).to have_content 'パスワードが入力されていません'
    
    #ニックネームが51文字の場合
    char51 = 'a' * 51
    fill_in 'user_nickname', with: char51
    click_button '新規登録'
    expect(page).to have_content 'ニックネームは50文字以内で入力してください'

    #パスワードが5文字以下の場合
    fill_in 'user_password', with: '12345'
    fill_in 'user_password_confirmation', with: '12345'
    click_button '新規登録'
    expect(page).to have_content 'パスワードは6文字以上で入力してください'

    #パスワードが一致しない場合
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'abcdefgh'
    click_button '新規登録'
    expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'

    # -----登録に成功する場合-----
    fill_in 'user_nickname', with: 'Bob'
    fill_in 'user_email', with: 'bob@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    expect { click_button '新規登録' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'

    #メールアドレスの本人確認をせずにログインする場合
    visit user_session_path
    fill_in 'user_email', with: 'bob@example.com'
    fill_in 'user_password', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content 'メールアドレスの本人確認が必要です。'

    new_user = User.last
    token = new_user.confirmation_token
    visit user_confirmation_path(confirmation_token: token)
    expect(page).to have_content 'メールアドレスが確認できました。' 
    expect(current_path).to eq new_user_session_path

    #新規登録したアカウントでログインをする
    fill_in 'user_email', with: 'bob@example.com'
    fill_in 'user_password', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。' 

    click_link 'マイページ'
    expect(page).to have_content 'Bob' 

    click_link 'ログアウト'
    expect(page).to have_content 'ログアウトしました。' 

    #登録したメールアドレスで別のアカウントを作成しようとするとエラーが発生することを確認
    click_link '新規登録'
    fill_in 'user_email', with: 'bob@example.com'
    click_button '新規登録'
    expect(page).to have_content 'メールアドレスはすでに存在します'

  end
end