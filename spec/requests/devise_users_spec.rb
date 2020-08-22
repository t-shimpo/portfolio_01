require 'rails_helper'

RSpec.describe "UserAuthentications", type: :request do
  let(:user) { create(:user) }
  let(:user_params) { attributes_for(:user) }
  let(:invalid_user_params) { attributes_for(:user, nickname: "") }

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

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.status).to eq 200
      end

      it '認証メールが送信されないこと' do
        post user_registration_path, params: { user: invalid_user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end

      it 'createが失敗すること' do
        expect do
          post user_registration_path, params: { user: invalid_user_params }
        end.to_not change(User, :count)
      end

      it 'エラーが表示されること' do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.body).to include 'ユーザ は保存されませんでした。'
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
        it 'リクエストが成功すること' do
          user_id = user.id
          get "/users/#{user_id}"
          expect(response.status).to eq 200
        end

        it 'エラーが発生しないこと' do
          user_id = user.id
          expect{ get "/users/#{user_id}" }.not_to raise_error
        end

        it 'ユーザー名が表示されていること' do
          user_id = user.id
          get "/users/#{user_id}"
          expect(response.body).to include user.nickname
        end

      end
      context '存在しないユーザのページを表示する場合' do
        it 'エラーが発生すること' do
          expect{ get "/users/999999" }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  describe 'GET #new' do
    it 'リクエストが成功すること' do
      get new_user_registration_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET #edit' do
    subject { get edit_user_registration_path }
    context 'ログインしている場合' do
      before do
        user.confirm
        sign_in user
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

  describe 'DELETE #destroy' do
    let!(:user) { FactoryBot.create :user }
    before do
      user.confirm
      sign_in user
    end

    it 'リクエストが成功すること' do
      delete  user_registration_path
      expect(response.status).to eq 302
    end

    it 'ユーザーが削除されること' do
      expect do
        delete  user_registration_path
      end.to change(User, :count).by(-1)
    end
  end

end