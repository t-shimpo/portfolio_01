require 'rails_helper'

describe UsesController, type: :controller do


  describe 'GET #index' do
    context '権限のあるユーザ' do
      it 'リクエストが成功すること' do
        get :index
        expect(response.status).to eq 200
      end
  
      it 'indexテンプレートが表示されること' do
        get :index
        expect(response).to render_template :index
      end
    end

    context 'ゲストユーザ' do
      it 'リクエストが成功すること' do
        get :index
        expect(response.status).to eq 200
      end
  
      it 'indexテンプレートが表示されること' do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #show' do
    context '権限のあるユーザ' do
      it 'リクエストが成功すること' do
        get :show
        expect(response.status).to eq 200
      end
  
      it 'showテンプレートが表示されること' do
        get :show
        expect(response).to render_template :show
      end
    end

    context 'ゲストユーザ' do
      it 'リクエストが成功すること' do
        get :show
        expect(response.status).to eq 200
      end
  
      it 'showテンプレートが表示されること' do
        get :show
        expect(response).to render_template :show
      end
    end
  end


end
