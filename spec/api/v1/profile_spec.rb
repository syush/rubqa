require 'rails_helper'

RSpec.describe "Profiles API" do
  describe "GET /me" do
    context "unauthorized" do
      it 'returns 401 status if request has no access token' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end
      it 'returns 401 status if the access token is invalid' do
        get '/api/v1/profiles/me', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end

    end
  end
end