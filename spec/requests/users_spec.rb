require 'rails_helper'

RSpec.describe "Users", type: :request do

  let!(:user) { create(:user) }
  let!(:takashi) { create(:takashi) }
  before do
    user.confirm
    takashi.confirm
  end

  describe "GET #index" do
    context "ログインしていないユーザの場合" do
      it "リクエストに成功すること" do
        get users_path
        expect(response).to have_http_status 200
      end
      it "ユーザー名が表示されていること" do
        get users_path
        expect(response.body).to include user.nickname
        expect(response.body).to include takashi.nickname
      end
    end

    context "ログインしているユーザの場合" do
      before do
        sign_in user
      end
      it "リクエストに成功すること" do
        get users_path
        expect(response).to have_http_status 200
      end
      it "ユーザー名が表示されていること" do
        get users_path
        expect(response.body).to include user.nickname
        expect(response.body).to include takashi.nickname
      end
    end
  end

  describe 'GET #show' do
    describe 'ログインしていないユーザのテスト' do
      it "リクエストが失敗すること" do
        get user_path user
        expect(response).to have_http_status 302
      end
      it 'ログインページが表示されること' do
        get user_path user
        is_expected.to redirect_to new_user_session_path
      end
    end

    describe 'ログイン済みのユーザのテスト' do
      before do
        sign_in user
      end
      context '自身のページを表示する場合' do
        it 'リクエストが成功すること' do
          get user_path user
          expect(response.status).to eq 200
        end
        it '自身のユーザー名が表示されていること' do
          get user_path user
          expect(response.body).to include user.nickname
        end
        it '編集ボタンが表示されていること' do
          get user_path user
          expect(response.body).to include '編集'
        end
      end

      context '他者のページを表示する場合' do
        it 'リクエストが成功すること' do
          get user_path takashi
          expect(response.status).to eq 200
        end
        it '他者のユーザー名が表示されていること' do
          get user_path takashi
          expect(response.body).to include takashi.nickname
        end
        it '編集ボタンが表示されていないこと' do
          get user_path takashi
          expect(response.body).to_not include '編集'
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
