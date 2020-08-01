require 'rails_helper'

RSpec.describe "UserAuthentications", type: :request do
  let(:user) { create(:user) }
  let(:user_params) { attributes_for(:user) }
  #以下は不正なパラメータ
  let(:blank_nickname_user_params) { attributes_for(:user, nickname: "") }
  let(:toolong_nickname_user_params) { attributes_for(:user, nickname: "aaaaabbbbbaaaaabbbbbaaaaabbbbbaaaaabbbbbaaaaabbbbba") }
  let(:blank_email_user_params) { attributes_for(:user, email: "") }
  let(:invalid_email_user_params) { attributes_for(:user, email: "test@test@example.com") }
  let(:tooshort_password_user_params) { attributes_for(:user, password: "aa", password_confirmation: "aa") }
  let(:not_match_pconfirmation_user_params) { attributes_for(:user, password_confirmation: "testtest") }

  describe 'POST #create' do
    before do
      ActionMailer::Base.deliveries.clear
    end

    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: {user: user_params}
        expect(response.status).to eq 302
      end

      it '認証メールが送信されること' do
        post user_registration_path, params: { user: user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it 'createが成功すること' do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by 1
      end

      it 'リダイレクトされること' do
        post user_registration_path, params: { user: user_params }
        expect(response).to redirect_to root_url
      end
    end

    context 'ニックネームが空の場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: blank_nickname_user_params }
        expect(response.status).to eq 200
      end

      it '認証メールが送信されないこと' do
        post user_registration_path, params: { user: blank_nickname_user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end

      it 'createが失敗すること' do
        expect do
          post user_registration_path, params: { user: blank_nickname_user_params }
        end.to_not change(User, :count)
      end

      it 'エラーが表示されること' do
        post user_registration_path, params: { user: blank_nickname_user_params }
        expect(response.body).to include 'ニックネームが入力されていません'
      end
    end

    context 'ニックネームが51文字以上の場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: toolong_nickname_user_params }
        expect(response.status).to eq 200
      end

      it '認証メールが送信されないこと' do
        post user_registration_path, params: { user: toolong_nickname_user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end

      it 'createが失敗すること' do
        expect do
          post user_registration_path, params: { user: toolong_nickname_user_params }
        end.to_not change(User, :count)
      end

      it 'エラーが表示されること' do
        post user_registration_path, params: { user: toolong_nickname_user_params }
        expect(response.body).to include 'ニックネームは50文字以内で入力してください'
      end
    end

    context 'メールアドレスが空の場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: blank_email_user_params }
        expect(response.status).to eq 200
      end

      it '認証メールが送信されないこと' do
        post user_registration_path, params: { user: blank_email_user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end

      it 'createが失敗すること' do
        expect do
          post user_registration_path, params: { user: blank_email_user_params }
        end.to_not change(User, :count)
      end

      it 'エラーが表示されること' do
        post user_registration_path, params: { user: blank_email_user_params }
        expect(response.body).to include 'メールアドレスが入力されていません'
      end
    end

    context '不正なメールアドレスの場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: invalid_email_user_params }
        expect(response.status).to eq 200
      end

      it '認証メールが送信されないこと' do
        post user_registration_path, params: { user: invalid_email_user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end

      it 'createが失敗すること' do
        expect do
          post user_registration_path, params: { user: invalid_email_user_params }
        end.to_not change(User, :count)
      end
    end

    context 'パスワードが5文字以下の場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: tooshort_password_user_params }
        expect(response.status).to eq 200
      end

      it '認証メールが送信されないこと' do
        post user_registration_path, params: { user: tooshort_password_user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end

      it 'createが失敗すること' do
        expect do
          post user_registration_path, params: { user: tooshort_password_user_params }
        end.to_not change(User, :count)
      end

      it 'エラーが表示されること' do
        post user_registration_path, params: { user: tooshort_password_user_params }
        expect(response.body).to include 'パスワードは6文字以上で入力してください'
      end
    end

    context 'パスワードと確認用パスワードが違う場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: not_match_pconfirmation_user_params }
        expect(response.status).to eq 200
      end

      it '認証メールが送信されないこと' do
        post user_registration_path, params: { user: not_match_pconfirmation_user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end

      it 'createが失敗すること' do
        expect do
          post user_registration_path, params: { user: not_match_pconfirmation_user_params }
        end.to_not change(User, :count)
      end

      it 'エラーが表示されること' do
        post user_registration_path, params: { user: not_match_pconfirmation_user_params }
        expect(response.body).to include '確認用パスワードとパスワードの入力が一致しません'
      end
    end
  end

  describe 'GET #edit' do
    subject { get edit_user_registration_path }
    context 'ログインしている場合' do
      before do
        user.confirm
        sign_in user
        # login_as user でもOK
      end
      it 'リクエストが成功すること' do
        is_expected.to eq 200
      end
    end
    context 'ゲストの場合' do
      it 'リダイレクトされること' do
        is_expected.to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #show' do
    describe 'ログインしていないユーザ' do
      context 'ユーザのページにアクセスした場合' do
        it 'ログインページが表示されること' do
          user.confirm
          user_id = user.id
          get "/users/#{user_id}" 
          is_expected.to redirect_to new_user_session_path
        end

      end
    end

    describe 'ログイン済みのユーザ' do
      before do
        user.confirm
        sign_in user
      end
      context '存在するユーザのページを表示する場合' do
        it 'エラーが発生しないこと' do
          user_id = user.id
          expect{ get "/users/#{user_id}" }.not_to raise_error
        end
      end
      context '存在しないユーザのページを表示する場合' do
        it 'エラーが発生すること' do
          expect{ get "/users/999999" }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end