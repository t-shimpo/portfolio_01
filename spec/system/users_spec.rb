require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:kenji) { create(:kenji) }
  let!(:michael) { create(:michael) }
  before do
    ActionMailer::Base.deliveries.clear
    kenji.confirm
    michael.confirm
  end

  #--------------------#
  #      新規登録      #
  #--------------------#

  describe '新規登録する' do
    #  -----  有効な値  -----  #
    context '有効な値を入力する場合' do
      before do
        visit root_path
        click_link '新規登録'
        fill_in 'user_nickname', with: 'たかよし'
        fill_in 'user_email', with: 'takayoshi@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
      end
      # 認証前
      context 'メール認証前' do
        it '登録確認メールが送信され、その旨のメッセージが表示されること' do
          expect { click_button '新規登録' }.to change { ActionMailer::Base.deliveries.size }.by(1)
          expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
        end
        it '認証前ではログインができないこと' do
          click_button '新規登録'
          click_link 'ログイン'
          fill_in 'user_email', with: 'takayoshi@example.com'
          fill_in 'user_password', with: 'password'
          click_button 'ログイン'
          expect(page).to have_content 'メールアドレスの本人確認が必要です。'
        end
        it '登録したメールアドレスで、別のアカウントを作成しようとするとエラーが表示されること' do
          click_button '新規登録'
          click_link '新規登録'
          fill_in 'user_email', with: 'takayoshi@example.com'
          click_button '新規登録'
          expect(page).to have_content 'メールアドレスはすでに存在します'
        end
      end

      # 認証後
      context 'メール認証後' do
        before do
          click_button '新規登録'
          takayoshi = User.last
          token = takayoshi.confirmation_token
          visit user_confirmation_path(confirmation_token: token)
        end
        it 'メール認証ができたメッセージが表示されること' do
          expect(page).to have_content 'メールアドレスが確認できました。'
          expect(current_path).to eq new_user_session_path
        end
        it '登録した情報が、ユーザ一覧ページに表示されること' do
          click_link 'ユーザ一覧'
          expect(page).to have_content 'たかよし'
        end
        it '登録したユーザでログイン、ログアウトができること' do
          fill_in 'user_email', with: 'takayoshi@example.com'
          fill_in 'user_password', with: 'password'
          click_button 'ログイン'
          expect(page).to have_content 'ログインしました。'
          click_link 'ログアウト'
          expect(page).to have_content 'ログアウトしました。'
        end

        # ログイン後
        context 'ログイン後' do
          before do
            fill_in 'user_email', with: 'takayoshi@example.com'
            fill_in 'user_password', with: 'password'
            click_button 'ログイン'
          end
          it '登録した情報が、ユーザ情報ページに表示されること' do
            click_link 'マイページ'
            expect(page).to have_content 'たかよし'
          end
          it '登録した情報が、ユーザ編集ページに表示されること' do
            click_link 'マイページ'
            click_link '編集'
            expect(page).to have_xpath "//input[@id='user_nickname'][@value='たかよし']"
            expect(page).to have_xpath "//input[@id='user_email'][@value='takayoshi@example.com']"
          end
          it '投稿ができること' do
            click_link '投稿する'
            fill_in 'post_title', with: 'ジェフ・ベゾス 果てなき野望'
            fill_in 'post_author', with: 'ブラッド・ストーン'
            click_button '投稿する'
            expect(page).to have_content '投稿されました。'
            click_link '本を探す'
            expect(page).to have_content 'ジェフ・ベゾス 果てなき野望'
          end
          it '各ユーザ画像はデフォルトの画像が表示されること' do
            click_link 'ユーザ一覧'
            expect(page).to have_css '.default-user-image'
            click_link 'マイページ'
            expect(page).to have_css '.default-user-image'
            click_link '編集'
            expect(page).to have_css '.default-user-image'
            click_link '投稿する'
            fill_in 'post_title', with: '「自分だけの答え」が見つかる 13歳からのアート思考'
            fill_in 'post_author', with: '末永 幸歩'
            click_button '投稿する'
            click_link '本を探す'
            expect(page).to have_css '.default-user-image'
            click_link 'ログアウト'
            click_link 'ログイン'
            login kenji
            click_link '本を探す'
            click_link '「自分だけの答え」が見つかる 13歳からのアート思考'
            expect(page).to have_css '.default-user-image'
          end
        end
      end
    end

    #  -----  無効な値  -----  #
    context '無効な値を入力する場合' do
      before do
        visit root_path
        click_link '新規登録'
      end
      it '値が空の場合、エラーが表示されること' do
        click_button '新規登録'
        expect(page).to have_content 'ユーザ は保存されませんでした。'
        expect(page).to have_content 'ニックネームを入力してください'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content 'パスワードを入力してください'
      end
      it 'ニックネームが51文字の場合、エラーが表示されること' do
        char51 = 'a' * 51
        fill_in 'user_nickname', with: char51
        click_button '新規登録'
        expect(page).to have_content 'ユーザ は保存されませんでした。'
        expect(page).to have_content 'ニックネームは50文字以内で入力してください'
      end
      it 'パスワードが5文字以下の場合、エラーが表示されること' do
        fill_in 'user_password', with: '12345'
        fill_in 'user_password_confirmation', with: '12345'
        click_button '新規登録'
        expect(page).to have_content 'ユーザ は保存されませんでした。'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
      end
      it 'パスワードが一致しない場合、エラーが表示されること' do
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'abcdefgh'
        click_button '新規登録'
        expect(page).to have_content 'ユーザ は保存されませんでした。'
        expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
      end
    end
  end

  #--------------------#
  #      ログイン      #
  #--------------------#

  describe 'ログインする' do
    # けんじでログインする
    before do
      visit root_path
      click_link 'ログイン'
    end
    #  -----  有効な値  -----  #
    context '有効な値を入力する場合' do
      it 'ログインした旨のメッセージが表示されること' do
        fill_in 'user_email', with: 'kenji@example.com'
        fill_in 'user_password', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'ログインしました。'
      end
    end
    #  -----  無効な値  -----  #
    context '無効な値を入力する場合' do
      it '値が空の場合、エラーが表示されること' do
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: ''
        click_button 'ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
      it 'メールアドレスは正しいが、パスワードが正しくない場合、エラーが表示されること' do
        fill_in 'user_email', with: 'kenij@example.com'
        fill_in 'user_password', with: 'abcdefgh'
        click_button 'ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
      it 'メールアドレスは正しくないが、パスワードが正しい場合、エラーが表示されること' do
        fill_in 'user_email', with: 'abcdefgh@example.com'
        fill_in 'user_password', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end
  end

  #--------------------#
  #   ユーザ情報変更   #
  #--------------------#

  describe 'ログインし、ユーザ情報を変更する' do
    # けんじでログインする
    before do
      visit root_path
      click_link 'ログイン'
      fill_in 'user_email', with: 'kenji@example.com'
      fill_in 'user_password', with: 'password'
      click_button 'ログイン'
      click_link 'マイページ'
      click_link '編集'
    end
    #  -----  有効な値  -----  #
    context '有効な値を入力する場合' do
      #  メールアドレス以外を変更
      context 'ユーザイメージ、ニックネーム、パスワードを変更するを変更する場合' do
        before do
          attach_file 'user_image', 'spec/file/test_image.png'
          fill_in 'user_nickname', with: 'ミナカワけんじ'
          fill_in 'user_email', with: 'kenji@example.com'
          fill_in 'user_password', with: 'newpassword'
          fill_in 'user_password_confirmation', with: 'newpassword'
          fill_in 'user_current_password', with: 'password'
          click_button '変更する'
        end
        it '変更ができたメッセージが表示されること' do
          expect(page).to have_content 'アカウント情報を変更しました。'
          expect(current_path).to eq root_path
        end
        it '変更した情報が、ユーザ一覧ページに表示されること' do
          click_link 'ユーザ一覧'
          expect(page).to have_content 'ミナカワけんじ'
        end
        it '変更した情報が、ユーザ情報ページに表示されること' do
          click_link 'マイページ'
          expect(page).to have_content 'ミナカワけんじ'
        end
        it '変更した情報が、ユーザ編集ページに表示されること' do
          click_link 'マイページ'
          click_link '編集'
          expect(page).to have_xpath "//input[@id='user_nickname'][@value='ミナカワけんじ']"
        end
        it '変更した情報でログイン、ログアウトができること' do
          click_link 'ログアウト'
          expect(page).to have_content 'ログアウトしました。'
          click_link 'ログイン'
          fill_in 'user_email', with: 'kenji@example.com'
          fill_in 'user_password', with: 'newpassword'
          click_button 'ログイン'
          expect(page).to have_content 'ログインしました。'
        end
        it '各ユーザ画像は変更後の画像が表示されること' do
          click_link 'ユーザ一覧'
          expect(page).to have_selector("img[src$='test_image.png']")
          click_link 'マイページ'
          expect(page).to have_selector("img[src$='test_image.png']")
          click_link '編集'
          expect(page).to have_selector("img[src$='test_image.png']")
          click_link '投稿する'
          fill_in 'post_title', with: '「自分だけの答え」が見つかる 13歳からのアート思考'
          fill_in 'post_author', with: '末永 幸歩'
          click_button '投稿する'
          click_link '本を探す'
          expect(page).to have_selector("img[src$='test_image.png']")
          click_link 'ログアウト'
          click_link 'ログイン'
          login michael
          click_link '本を探す'
          click_link '「自分だけの答え」が見つかる 13歳からのアート思考'
          expect(page).to have_selector("img[src$='test_image.png']")
        end
      end

      #  メールアドレスを変更
      context 'メールアドレスを変更する場合' do
        before do
          fill_in 'user_email', with: 'new_kenji@example.com'
          fill_in 'user_current_password', with: 'password'
        end
        it 'メールが送信され、その旨のメッセージが表示されること' do
          expect { click_button '変更する' }.to change { ActionMailer::Base.deliveries.size }.by(1)
          expect(page).to have_content 'アカウント情報を変更しました。変更されたメールアドレスの本人確認のため、本人確認用メールより確認処理をおこなってください。'
          expect(current_path).to eq root_path
        end
        context 'メール認証後' do
          before do
            click_button '変更する'
            user = User.find_by(nickname: 'けんじ')
            token = user.confirmation_token
            visit user_confirmation_path(confirmation_token: token)
          end
          it 'メールアドレスを確認できたメッセージが表示されること' do
            expect(page).to have_content 'メールアドレスが確認できました。'
            expect(current_path).to eq root_path
          end
          it '変更した情報が、ユーザ編集ページに表示されること' do
            click_link 'マイページ'
            click_link '編集'
            expect(page).to have_xpath "//input[@id='user_email'][@value='new_kenji@example.com']"
          end
          it '変更した情報でログイン、ログアウトができること' do
            click_link 'ログアウト'
            expect(page).to have_content 'ログアウトしました。'
            click_link 'ログイン'
            fill_in 'user_email', with: 'new_kenji@example.com'
            fill_in 'user_password', with: 'password'
            click_button 'ログイン'
            expect(page).to have_content 'ログインしました。'
          end
        end
      end
    end

    #  -----  無効な値  -----  #
    context '無効な値を入力する場合' do
      it '現在のパスワード空欄の場合、エラーが表示されること' do
        fill_in 'user_current_password', with: ''
        click_button '変更する'
        expect(page).to have_content 'ユーザ は保存されませんでした。'
        expect(page).to have_content '現在のパスワードを入力してください'
      end
      it '現在のパスワードが正しくない場合、エラーが表示されること' do
        fill_in 'user_nickname', with: 'new_kenji'
        fill_in 'user_current_password', with: 'invalidpassword'
        click_button '変更する'
        expect(page).to have_content 'ユーザ は保存されませんでした。'
        expect(page).to have_content '現在のパスワードは不正な値です'
      end
      it 'ニックネームの値が51文字の場合、エラーが表示されること' do
        char51 = 'a' * 51
        fill_in 'user_nickname', with: char51
        fill_in 'user_current_password', with: 'password'
        click_button '変更する'
        expect(page).to have_content 'ユーザ は保存されませんでした。'
        expect(page).to have_content 'ニックネームは50文字以内で入力してください'
      end
      it 'メールアドレスが空欄の場合、エラーが表示されること' do
        fill_in 'user_email', with: ''
        fill_in 'user_current_password', with: 'password'
        click_button '変更する'
        expect(page).to have_content 'ユーザ は保存されませんでした。'
        expect(page).to have_content 'メールアドレスを入力してください'
      end
      it '新しいパスワードが5文字以下の場合、エラーが表示されること' do
        fill_in 'user_nickname', with: 'new_kenji'
        fill_in 'user_password', with: 'abcde'
        fill_in 'user_password_confirmation', with: 'abcde'
        fill_in 'user_current_password', with: 'password'
        click_button '変更する'
        expect(page).to have_content 'ユーザ は保存されませんでした。'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
      end
    end
  end

  describe 'ユーザはログインしなければ、ユーザ情報ページをできない' do
    it 'ユーザ情報ページが表示できず、エラーメッセージが表示されること' do
      visit users_path
      click_link 'けんじ'
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(current_path).to eq new_user_session_path
    end
  end

  #--------------------#
  #  パスワード再設定  #
  #--------------------#

  describe 'ユーザのパスワードを再設定する' do
    before do
      visit new_user_session_path
      click_link 'パスワードを忘れた場合'
    end
    context '存在するメールアドレスを送信する場合' do
      before { fill_in 'user_email', with: 'kenji@example.com' }
      it '再設定についてのメールを送信する旨のメッセージが表示されること' do
        expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(page).to have_content 'パスワードの再設定について数分以内にメールでご連絡いたします。'
      end
    end
    context '存在しないメールアドレスを送信する場合' do
      it 'エラーメッセージ表示されること' do
        fill_in 'user_email', with: 'invalid@example.com'
        click_button '送信'
        expect(page).to have_content 'ユーザ は保存されませんでした。'
        expect(page).to have_content 'メールアドレスは見つかりませんでした。'
      end
    end
  end

  #--------------------#
  #  登録メール再送信  #
  #--------------------#

  describe '登録確認メールを再送信する' do
    before do
      visit root_path
      click_link '新規登録'
      fill_in 'user_nickname', with: 'たかよし'
      fill_in 'user_email', with: 'takayoshi@example.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button '新規登録'
      click_link '新規登録'
      click_link '登録確認メールが届かない場合'
    end
    #  ----- 存在するメールアドレス ------
    context '存在するメールアドレスを入力する場合' do
      before { fill_in 'user_email', with: 'takayoshi@example.com' }
      it 'メールを送信する旨のメッセージが表示されること' do
        expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(page).to have_content 'アカウントの有効化について数分以内にメールでご連絡します。'
      end
      it 'メールアドレスの確認ができること' do
        click_button '送信'
        takayoshi = User.last
        token = takayoshi.confirmation_token
        visit user_confirmation_path(confirmation_token: token)
        expect(page).to have_content 'メールアドレスが確認できました。'
        expect(current_path).to eq new_user_session_path
      end
    end

    #  ----- 存在しないメールアドレス ------
    context '存在しないメールアドレスを入力する場合' do
      it 'エラーメッセージ表示されること' do
        fill_in 'user_email', with: 'invalid@example.com'
        click_button '送信'
        expect(page).to have_content 'ユーザ は保存されませんでした。'
        expect(page).to have_content 'メールアドレスは見つかりませんでした。'
      end
    end
  end

  #--------------------#
  #        削除        #
  #--------------------#

  describe 'ユーザを削除する', js: true do
    before do
      visit new_user_session_path
      login kenji
      click_link 'マイページ'
      click_link '編集'
      click_button 'アカウントを削除する'
      page.driver.browser.switch_to.alert.accept
    end
    it '削除に成功したメッセージが表示されること' do
      expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
      expect(current_path).to eq root_path
    end
    it '削除したユーザがユーザ一覧に表示されていないこと' do
      visit users_path
      expect(page).to_not have_content 'けんじ'
    end
  end
end
