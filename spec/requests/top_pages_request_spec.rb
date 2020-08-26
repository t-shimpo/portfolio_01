require 'rails_helper'

RSpec.describe "TopPages", type: :request do

    describe "GET #index" do
      it "リクエストが成功すること" do
        get root_path
        expect(response).to have_http_status 200
      end
    end  

end
