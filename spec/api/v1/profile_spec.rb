require 'rails_helper'

RSpec.describe "Profiles API" do
  describe "GET /me" do

    it_behaves_like "API Authenticable" do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).not_to have_json_path(attr)
        end
      end


    end

  end

  describe "GET /other_users" do
    context "unauthorized" do
      it 'returns 401 status if request has no access token' do
        get '/api/v1/profiles', format: :json
        expect(response.status).to eq 401
      end
      it 'returns 401 status if the access token is invalid' do
        get '/api/v1/profiles', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end


    end

    context 'authorized' do
      let(:me) { create(:user, admin: true) }
      let!(:john) { create(:user) }
      let!(:paul) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'includes all users minus 1' do
        expect(response.body).to have_json_size(2).at_path("profiles/")
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(john.send(attr).to_json).at_path("profiles/0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).not_to have_json_path(attr)
        end
      end


    end


  end


end