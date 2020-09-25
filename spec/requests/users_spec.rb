require 'rails_helper'

RSpec.describe "Users", type: :request do

  let!(:user) { create(:user) }
  let!(:takashi) { create(:takashi) }
  before do
    user.confirm
    takashi.confirm
  end
  
  #  -----  index ------  
  #  -------------------
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

  #  -----  show  ------  
  #  -------------------
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
        it '最新の投稿というタイトルが表示されていること' do
          get user_path user
          expect(response.body).to include '最新の投稿'
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
        it '最新の投稿というタイトルが表示されていること' do
          get user_path user
          expect(response.body).to include '最新の投稿'
        end
      end

      context '存在しないユーザのページを表示する場合' do
        it 'エラーが発生すること' do
          expect{ get "/users/999999" }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  #  -----  posts ------  
  #  -------------------
  describe 'GET #posts' do
    describe 'ログインしていないユーザのテスト' do
      it "リクエストが失敗すること" do
        get posts_user_path user
        expect(response).to have_http_status 302
      end
      it 'ログインページが表示されること' do
        get posts_user_path user
        is_expected.to redirect_to new_user_session_path
      end
    end

    describe 'ログイン済みのユーザのテスト' do
      before do
        sign_in user
      end
      context '自身のページを表示する場合' do
        it 'リクエストが成功すること' do
          get posts_user_path user
          expect(response.status).to eq 200
        end
        it '自身のユーザー名が表示されていること' do
          get posts_user_path user
          expect(response.body).to include user.nickname
        end
        it '編集ボタンが表示されていること' do
          get posts_user_path user
          expect(response.body).to include '編集'
        end
        it '投稿一覧というタイトルが表示されていること' do
          get posts_user_path user
          expect(response.body).to include '投稿一覧 0 件'
        end
      end

      context '他者のページを表示する場合' do
        it 'リクエストが成功すること' do
          get posts_user_path takashi
          expect(response.status).to eq 200
        end
        it '他者のユーザー名が表示されていること' do
          get posts_user_path takashi
          expect(response.body).to include takashi.nickname
        end
        it '編集ボタンが表示されていないこと' do
          get posts_user_path takashi
          expect(response.body).to_not include '編集'
        end
        it '投稿一覧というタイトルが表示されていること' do
          get posts_user_path user
          expect(response.body).to include '投稿一覧 0 件'
        end
      end

      context '存在しないユーザのページを表示する場合' do
        it 'エラーが発生すること' do
          expect{ get "/users/999999/posts" }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  #  -----following------  
  #  --------------------
  describe 'GET #following' do
    describe 'ログインしていないユーザのテスト' do
      it "リクエストが失敗すること" do
        get following_user_path user
        expect(response).to have_http_status 302
      end
      it 'ログインページが表示されること' do
        get following_user_path user
        is_expected.to redirect_to new_user_session_path
      end
    end

    describe 'ログイン済みのユーザのテスト' do
      before do
        sign_in user
      end
      context '自身のページを表示する場合' do
        it 'リクエストが成功すること' do
          get following_user_path user
          expect(response.status).to eq 200
        end
        it '自身のユーザー名が表示されていること' do
          get following_user_path user
          expect(response.body).to include user.nickname
        end
        it '編集ボタンが表示されていること' do
          get following_user_path user
          expect(response.body).to include '編集'
        end
        it 'フォローというタイトルが表示されていること' do
          get following_user_path user
          expect(response.body).to include 'フォロー 0 人'
        end
      end

      context '他者のページを表示する場合' do
        it 'リクエストが成功すること' do
          get following_user_path takashi
          expect(response.status).to eq 200
        end
        it '他者のユーザー名が表示されていること' do
          get following_user_path takashi
          expect(response.body).to include takashi.nickname
        end
        it '編集ボタンが表示されていないこと' do
          get following_user_path takashi
          expect(response.body).to_not include '編集'
        end
        it 'フォローというタイトルが表示されていること' do
          get following_user_path user
          expect(response.body).to include 'フォロー 0 人'
        end
      end

      context '存在しないユーザのページを表示する場合' do
        it 'エラーが発生すること' do
          expect{ get "/users/999999/following" }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  #  -----followers------  
  #  --------------------
  describe 'GET #followers' do
    describe 'ログインしていないユーザのテスト' do
      it "リクエストが失敗すること" do
        get followers_user_path user
        expect(response).to have_http_status 302
      end
      it 'ログインページが表示されること' do
        get followers_user_path user
        is_expected.to redirect_to new_user_session_path
      end
    end

    describe 'ログイン済みのユーザのテスト' do
      before do
        sign_in user
      end
      context '自身のページを表示する場合' do
        it 'リクエストが成功すること' do
          get followers_user_path user
          expect(response.status).to eq 200
        end
        it '自身のユーザー名が表示されていること' do
          get followers_user_path user
          expect(response.body).to include user.nickname
        end
        it '編集ボタンが表示されていること' do
          get followers_user_path user
          expect(response.body).to include '編集'
        end
        it 'フォロワーというタイトルが表示されていること' do
          get followers_user_path user
          expect(response.body).to include 'フォロワー 0 人'
        end
      end

      context '他者のページを表示する場合' do
        it 'リクエストが成功すること' do
          get followers_user_path takashi
          expect(response.status).to eq 200
        end
        it '他者のユーザー名が表示されていること' do
          get followers_user_path takashi
          expect(response.body).to include takashi.nickname
        end
        it '編集ボタンが表示されていないこと' do
          get followers_user_path takashi
          expect(response.body).to_not include '編集'
        end
        it 'フォロワーというタイトルが表示されていること' do
          get followers_user_path user
          expect(response.body).to include 'フォロワー 0 人'
        end
      end

      context '存在しないユーザのページを表示する場合' do
        it 'エラーが発生すること' do
          expect{ get "/users/999999/followers" }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  #  -----  likes ------  
  #  -------------------
  describe 'GET #likes' do
    describe 'ログインしていないユーザのテスト' do
      it "リクエストが失敗すること" do
        get likes_user_path user
        expect(response).to have_http_status 302
      end
      it 'ログインページが表示されること' do
        get likes_user_path user
        is_expected.to redirect_to new_user_session_path
      end
    end

    describe 'ログイン済みのユーザのテスト' do
      before do
        sign_in user
      end
      context '自身のページを表示する場合' do
        it 'リクエストが成功すること' do
          get likes_user_path user
          expect(response.status).to eq 200
        end
        it '自身のユーザー名が表示されていること' do
          get likes_user_path user
          expect(response.body).to include user.nickname
        end
        it '編集ボタンが表示されていること' do
          get likes_user_path user
          expect(response.body).to include '編集'
        end
        it 'いいねした投稿というタイトルが表示されていること' do
          get likes_user_path user
          expect(response.body).to include 'いいねした投稿 0 件'
        end
      end

      context '他者のページを表示する場合' do
        it 'リクエストが成功すること' do
          get likes_user_path takashi
          expect(response.status).to eq 200
        end
        it '他者のユーザー名が表示されていること' do
          get likes_user_path takashi
          expect(response.body).to include takashi.nickname
        end
        it '編集ボタンが表示されていないこと' do
          get likes_user_path takashi
          expect(response.body).to_not include '編集'
        end
        it 'いいねした投稿というタイトルが表示されていること' do
          get likes_user_path user
          expect(response.body).to include 'いいねした投稿 0 件'
        end
      end

      context '存在しないユーザのページを表示する場合' do
        it 'エラーが発生すること' do
          expect{ get "/users/999999/likes" }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
  
  #  -----comments------  
  #  -------------------
  describe 'GET #comments' do
    describe 'ログインしていないユーザのテスト' do
      it "リクエストが失敗すること" do
        get comments_user_path user
        expect(response).to have_http_status 302
      end
      it 'ログインページが表示されること' do
        get comments_user_path user
        is_expected.to redirect_to new_user_session_path
      end
    end

    describe 'ログイン済みのユーザのテスト' do
      before do
        sign_in user
      end
      context '自身のページを表示する場合' do
        it 'リクエストが成功すること' do
          get comments_user_path user
          expect(response.status).to eq 200
        end
        it '自身のユーザー名が表示されていること' do
          get comments_user_path user
          expect(response.body).to include user.nickname
        end
        it '編集ボタンが表示されていること' do
          get comments_user_path user
          expect(response.body).to include '編集'
        end
        it 'コメントした投稿というタイトルが表示されていること' do
          get comments_user_path user
          expect(response.body).to include 'コメントした投稿 0 件'
        end
      end

      context '他者のページを表示する場合' do
        it 'リクエストが成功すること' do
          get comments_user_path takashi
          expect(response.status).to eq 200
        end
        it '他者のユーザー名が表示されていること' do
          get comments_user_path takashi
          expect(response.body).to include takashi.nickname
        end
        it '編集ボタンが表示されていないこと' do
          get comments_user_path takashi
          expect(response.body).to_not include '編集'
        end
        it 'コメントした投稿というタイトルが表示されていること' do
          get comments_user_path user
          expect(response.body).to include 'コメントした投稿 0 件'
        end
      end

      context '存在しないユーザのページを表示する場合' do
        it 'エラーが発生すること' do
          expect{ get "/users/999999/comments" }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

end
