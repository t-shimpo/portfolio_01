require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let!(:takashi) { create(:takashi) }
  let!(:michael) { create(:michael) }
  before do
    takashi.confirm
    michael.confirm
  end
  let!(:jibun_nonakani_doku) { create(:jibun_nonakani_doku, user_id: takashi.id) }
  let!(:hibana) { create(:hibana, user_id: michael.id) }

  let!(:education) { create(:post, genre: 'education') }
  let!(:art_ent) { create(:post, genre: 'art_ent') }
  let!(:celebrity) { create(:post, genre: 'celebrity') }
  let!(:hobby) { create(:post, genre: 'hobby') }
  let!(:geography) { create(:post, genre: 'geography') }
  let!(:child) { create(:post, genre: 'child') }
  let!(:others) { create(:post, genre: 'others') }

  describe 'GET #index' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが成功すること' do
        get posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get posts_path
        expect(response.body).to include jibun_nonakani_doku.title
        expect(response.body).to include hibana.title
        expect(response.body).to include education.title
        expect(response.body).to include art_ent.title
        expect(response.body).to include celebrity.title
        expect(response.body).to include hobby.title
        expect(response.body).to include geography.title
        expect(response.body).to include child.title
        expect(response.body).to include others.title
      end
    end

    context 'ログインしているユーザの場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        get posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get posts_path
        expect(response.body).to include jibun_nonakani_doku.title
        expect(response.body).to include hibana.title
      end
    end
  end

  describe 'GET #new' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが失敗すること' do
        get new_post_path
        expect(response).to have_http_status 302
      end
      it 'ログインページが表示されること' do
        get new_post_path
        is_expected.to redirect_to new_user_session_path
      end
    end

    context 'ログインしているユーザの場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        get new_post_path
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'GET #show' do
    describe 'ログインしていないユーザのテスト' do
      it 'リクエストが失敗すること' do
        get post_path hibana
        expect(response).to have_http_status 302
      end
      it 'ログインページが表示されること' do
        get post_path hibana
        is_expected.to redirect_to new_user_session_path
      end
    end

    describe 'ログイン済みのユーザのテスト' do
      before do
        sign_in takashi
      end
      context '自身の投稿の詳細を表示する場合' do
        it 'リクエストが成功すること' do
          get post_path jibun_nonakani_doku
          expect(response.status).to eq 200
        end
        it '投稿の詳細が表示されていること' do
          get post_path jibun_nonakani_doku
          expect(response.body).to include jibun_nonakani_doku.title
          expect(response.body).to include jibun_nonakani_doku.author
          expect(response.body).to include jibun_nonakani_doku.publisher
        end
        it '編集ボタンが表示されていること' do
          get post_path jibun_nonakani_doku
          expect(response.body).to include '編集'
        end
      end
      context '他者の投稿の詳細を表示する場合' do
        it 'リクエストが成功すること' do
          get post_path hibana
          expect(response.status).to eq 200
        end
        it '投稿の詳細が表示されていること' do
          get post_path hibana
          expect(response.body).to include hibana.title
          expect(response.body).to include hibana.author
          expect(response.body).to include hibana.publisher
        end
        it '編集ボタンが表示されていないこと' do
          get post_path hibana
          expect(response.body).to_not include '編集'
        end
      end
      context '存在しない投稿の詳細を表示する場合' do
        it 'エラーが発生すること' do
          expect { get '/posts/999999' }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  describe 'GET #edit' do
    describe 'ログインしていないユーザのテスト' do
      it 'リクエストが失敗すること' do
        get edit_post_path hibana
        expect(response).to have_http_status 302
      end
      it 'ログインページが表示されること' do
        get edit_post_path hibana
        is_expected.to redirect_to new_user_session_path
      end
    end

    describe 'ログインしているユーザのテスト' do
      context '投稿したユーザが投稿編集ページを開く場合' do
        before do
          sign_in michael
        end
        it 'リクエストが成功すること' do
          get edit_post_path hibana
          expect(response).to have_http_status 200
        end
        it '投稿のタイトル・著者が表示されていること' do
          get edit_post_path hibana
          expect(response.body).to include hibana.title
          expect(response.body).to include hibana.author
        end
      end

      context '投稿していないユーザが投稿編集ページを開く場合' do
        before do
          sign_in takashi
        end
        it 'リクエストが失敗すること' do
          get edit_post_path hibana
          expect(response).to have_http_status 302
        end
      end
    end
  end

  describe 'POST #create' do
    context 'パラメータが妥当な場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        post posts_url, params: { post: FactoryBot.attributes_for(:post, user_id: takashi.id) }
        expect(response.status).to eq 302
      end
      it 'createが成功すること' do
        expect do
          post posts_url, params: { post: FactoryBot.attributes_for(:post, user_id: takashi.id) }
        end.to change(Post, :count).by 1
      end
      it 'リダイレクトされること' do
        post posts_url, params: { post: FactoryBot.attributes_for(:post, user_id: takashi.id) }
        expect(response).to redirect_to new_post_url
      end
    end

    context 'パラメータが不正な場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        post posts_url, params: { post: FactoryBot.attributes_for(:post, title: '') }
        expect(response.status).to eq 200
      end
      it 'createが失敗すること' do
        expect do
          post posts_url, params: { post: FactoryBot.attributes_for(:post, title: '') }
        end.to_not change(Post, :count)
      end
      it 'エラーが表示されること' do
        post posts_url, params: { post: FactoryBot.attributes_for(:post, title: '') }
        expect(response.body).to include '投稿 は保存されませんでした。'
      end
    end
  end

  describe 'PUT #update' do
    context 'パラメータが妥当な場合' do
      before do
        sign_in michael
      end
      it 'リクエストが成功すること' do
        put post_path hibana, params: { post: FactoryBot.attributes_for(:hibana, title: '改良火花') }
        expect(response.status).to eq 302
      end
      it '投稿のタイトルが変更されること' do
        expect do
          put post_path hibana, params: { post: FactoryBot.attributes_for(:post, title: '改良火花') }
        end.to change { Post.find(hibana.id).title }.from('火花').to('改良火花')
      end
      it 'リダイレクトされること' do
        put post_path hibana, params: { post: FactoryBot.attributes_for(:post, title: '改良火花') }
        expect(response).to redirect_to post_url hibana
      end
    end

    context 'パラメータが不正な場合' do
      before do
        sign_in michael
      end
      it 'リクエストが成功すること' do
        put post_path hibana, params: { post: FactoryBot.attributes_for(:hibana, title: '') }
        expect(response.status).to eq 200
      end
      it '投稿のタイトルが変更されないこと' do
        expect do
          put post_path hibana, params: { post: FactoryBot.attributes_for(:post, title: '') }
        end.to_not change(Post.find(hibana.id), :title)
      end
      it 'エラーが表示されること' do
        put post_path hibana, params: { post: FactoryBot.attributes_for(:post, title: '') }
        expect(response.body).to include '投稿 は保存されませんでした。'
      end
    end
  end

  describe 'DELETE #destroy' do
    context '投稿したユーザが削除する場合' do
      before do
        sign_in michael
      end
      it 'リクエストが成功すること' do
        delete post_path hibana
        expect(response.status).to eq 302
      end
      it '投稿が削除されること' do
        expect do
          delete post_path hibana
        end.to change(Post, :count).by(-1)
      end
      it 'リダイレクトされること' do
        delete post_path hibana
        expect(response).to redirect_to user_url michael
      end
    end
    context '投稿していないユーザが削除する場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        delete post_path hibana
        expect(response.status).to eq 302
      end
      it '投稿が削除されないこと' do
        expect do
          delete post_path hibana
        end.to_not change(Post, :count)
      end
    end
  end

  describe 'GET #liked_users' do
    describe 'ログインしていないユーザのテスト' do
      it 'リクエストが失敗すること' do
        get liked_users_post_path hibana
        expect(response).to have_http_status 302
      end
      it 'ログインページが表示されること' do
        get liked_users_post_path hibana
        is_expected.to redirect_to new_user_session_path
      end
    end

    describe 'ログイン済みのユーザのテスト' do
      before do
        sign_in takashi
      end
      context '自身の投稿のいいねしたユーザを表示する場合' do
        it 'リクエストが成功すること' do
          get liked_users_post_path jibun_nonakani_doku
          expect(response.status).to eq 200
        end
        it 'タイトルが表示されていること' do
          get liked_users_post_path jibun_nonakani_doku
          expect(response.body).to include 'いいねしたユーザ 0 人'
        end
        it '投稿の内容が表示されていること' do
          get liked_users_post_path jibun_nonakani_doku
          expect(response.body).to include 'たかし'
          expect(response.body).to include jibun_nonakani_doku.title
          expect(response.body).to include jibun_nonakani_doku.author
        end
      end
      context '他者の投稿のいいねしたユーザを表示する場合' do
        it 'リクエストが成功すること' do
          get liked_users_post_path hibana
          expect(response.status).to eq 200
        end
        it 'タイトルが表示されていること' do
          get liked_users_post_path jibun_nonakani_doku
          expect(response.body).to include 'いいねしたユーザ 0 人'
        end
        it '投稿の内容が表示されていること' do
          get liked_users_post_path jibun_nonakani_doku
          expect(response.body).to include 'たかし'
          expect(response.body).to include jibun_nonakani_doku.title
          expect(response.body).to include jibun_nonakani_doku.author
        end
      end
      context '存在しない投稿の詳細を表示する場合' do
        it 'エラーが発生すること' do
          expect { get '/posts/999999/liked_users' }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  describe 'GET #novel' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが成功すること' do
        get novel_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get novel_posts_path
        expect(response.body).to include hibana.title
      end
    end

    context 'ログインしているユーザの場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        get novel_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get novel_posts_path
        expect(response.body).to include hibana.title
      end
    end
  end

  describe 'GET #business' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが成功すること' do
        get business_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get business_posts_path
        expect(response.body).to include jibun_nonakani_doku.title
      end
    end

    context 'ログインしているユーザの場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        get business_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get business_posts_path
        expect(response.body).to include jibun_nonakani_doku.title
      end
    end
  end

  describe 'GET #education' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが成功すること' do
        get education_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get education_posts_path
        expect(response.body).to include education.title
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        get education_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get education_posts_path
        expect(response.body).to include education.title
      end
    end
  end

  describe 'GET #art_ent' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが成功すること' do
        get art_ent_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get art_ent_posts_path
        expect(response.body).to include art_ent.title
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        get art_ent_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get art_ent_posts_path
        expect(response.body).to include art_ent.title
      end
    end
  end

  describe 'GET #celebrity' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが成功すること' do
        get celebrity_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get celebrity_posts_path
        expect(response.body).to include celebrity.title
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        get celebrity_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get celebrity_posts_path
        expect(response.body).to include celebrity.title
      end
    end
  end

  describe 'GET #hobby' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが成功すること' do
        get hobby_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get hobby_posts_path
        expect(response.body).to include hobby.title
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        get hobby_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get hobby_posts_path
        expect(response.body).to include hobby.title
      end
    end
  end

  describe 'GET #geography' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが成功すること' do
        get geography_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get geography_posts_path
        expect(response.body).to include geography.title
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        get geography_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get geography_posts_path
        expect(response.body).to include geography.title
      end
    end
  end

  describe 'GET #child' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが成功すること' do
        get child_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get child_posts_path
        expect(response.body).to include child.title
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        get child_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get child_posts_path
        expect(response.body).to include child.title
      end
    end
  end

  describe 'GET #others' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが成功すること' do
        get others_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get others_posts_path
        expect(response.body).to include others.title
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in takashi
      end
      it 'リクエストが成功すること' do
        get others_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get others_posts_path
        expect(response.body).to include others.title
      end
    end
  end
end
