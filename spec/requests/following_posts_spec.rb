require 'rails_helper'

RSpec.describe 'FollowingPosts', type: :request do
  let!(:takashi) { create(:takashi) }
  let!(:michael) { create(:michael) }
  before do
    takashi.confirm
    michael.confirm
    Relationship.create(follower_id: michael.id, following_id: takashi.id)
  end
  let!(:jibun_nonakani_doku) { create(:jibun_nonakani_doku, user_id: takashi.id) }
  let!(:hibana) { create(:hibana, user_id: takashi.id) }
  let!(:education) { create(:post, genre: 'education', user_id: takashi.id) }
  let!(:art_ent) { create(:post, genre: 'art_ent', user_id: takashi.id) }
  let!(:celebrity) { create(:post, genre: 'celebrity', user_id: takashi.id) }
  let!(:hobby) { create(:post, genre: 'hobby', user_id: takashi.id) }
  let!(:geography) { create(:post, genre: 'geography', user_id: takashi.id) }
  let!(:child) { create(:post, genre: 'child', user_id: takashi.id) }
  let!(:others) { create(:post, genre: 'others', user_id: takashi.id) }

  describe 'GET #index' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが失敗すること' do
        get following_posts_path
        expect(response).to have_http_status 302
      end
    end

    context 'ログインしているユーザの場合' do
      before do
        sign_in michael
      end
      it 'リクエストが成功すること' do
        get following_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get following_posts_path
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
  end

  describe 'GET #novel' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが失敗すること' do
        get novel_following_posts_path
        expect(response).to have_http_status 302
      end
    end

    context 'ログインしているユーザの場合' do
      before do
        sign_in michael
      end
      it 'リクエストが成功すること' do
        get novel_following_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get novel_following_posts_path
        expect(response.body).to include hibana.title
      end
    end
  end

  describe 'GET #business' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが失敗すること' do
        get business_following_posts_path
        expect(response).to have_http_status 302
      end
    end

    context 'ログインしているユーザの場合' do
      before do
        sign_in michael
      end
      it 'リクエストが成功すること' do
        get business_following_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get business_following_posts_path
        expect(response.body).to include jibun_nonakani_doku.title
      end
    end
  end

  describe 'GET #education' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが失敗すること' do
        get education_following_posts_path
        expect(response).to have_http_status 302
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in michael
      end
      it 'リクエストが成功すること' do
        get education_following_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get education_following_posts_path
        expect(response.body).to include education.title
      end
    end
  end

  describe 'GET #art_ent' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが失敗すること' do
        get art_ent_following_posts_path
        expect(response).to have_http_status 302
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in michael
      end
      it 'リクエストが成功すること' do
        get art_ent_following_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get art_ent_following_posts_path
        expect(response.body).to include art_ent.title
      end
    end
  end

  describe 'GET #celebrity' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが失敗すること' do
        get celebrity_following_posts_path
        expect(response).to have_http_status 302
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in michael
      end
      it 'リクエストが成功すること' do
        get celebrity_following_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get celebrity_following_posts_path
        expect(response.body).to include celebrity.title
      end
    end
  end

  describe 'GET #hobby' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが失敗すること' do
        get hobby_following_posts_path
        expect(response).to have_http_status 302
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in michael
      end
      it 'リクエストが成功すること' do
        get hobby_following_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get hobby_following_posts_path
        expect(response.body).to include hobby.title
      end
    end
  end

  describe 'GET #geography' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが失敗すること' do
        get geography_following_posts_path
        expect(response).to have_http_status 302
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in michael
      end
      it 'リクエストが成功すること' do
        get geography_following_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get geography_following_posts_path
        expect(response.body).to include geography.title
      end
    end
  end

  describe 'GET #child' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが失敗すること' do
        get child_following_posts_path
        expect(response).to have_http_status 302
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in michael
      end
      it 'リクエストが成功すること' do
        get child_following_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get child_following_posts_path
        expect(response.body).to include child.title
      end
    end
  end

  describe 'GET #others' do
    context 'ログインしていないユーザの場合' do
      it 'リクエストが失敗すること' do
        get others_following_posts_path
        expect(response).to have_http_status 302
      end
    end
    context 'ログインしているユーザの場合' do
      before do
        sign_in michael
      end
      it 'リクエストが成功すること' do
        get others_following_posts_path
        expect(response).to have_http_status 200
      end
      it '投稿のタイトルが表示されていること' do
        get others_following_posts_path
        expect(response.body).to include others.title
      end
    end
  end
end
