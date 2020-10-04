require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  let!(:user) { create(:user) }

  describe 'GET #index' do
    subject { get notifications_path }
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
end
