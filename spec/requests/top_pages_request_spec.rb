require 'rails_helper'

RSpec.describe "TopPages", type: :request do

    describe "GET #index" do
      example "トップページの表示に成功すること" do
        get root_path
        expect(response).to have_http_status 200
      end
    end  

end
