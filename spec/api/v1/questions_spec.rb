require 'rails_helper'

RSpec.describe "Questions API" do
  describe "GET /index" do
    context "unauthorized" do
      it 'returns 401 status if access token is invalid' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end


    end


    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 2, user:user) }
      let(:question) { questions.first }
      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("questions/0/#{attr}")
        end
      end

    end

    context 'answers' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:questions) { create_list(:question, 2, user:user) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question:  question, user:other_user) }
      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'included in question' do
        expect(response.body).to have_json_size(1).at_path('questions/0/answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("questions/0/answers/0/#{attr}")
        end
      end

    end
  end

  describe "GET /:id" do
    context "unauthorized" do
      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/0", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/questions/0', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end

    end


    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:questions) { create_list(:question, 2, user:user) }
      let(:question) { questions.first }
      let!(:attachments) { create_list(:attachment, 3, attachable: question) }
      let!(:answer) { create(:answer, question:  question, user:other_user) }
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("question/#{attr}")
        end
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(3).at_path('question/attachments')
      end

      it "contains file attachments" do
        expect(response.body).to be_json_eql(attachments[0].id).at_path("question/attachments/2/id")
        expect(response.body).to be_json_eql(attachments[0].file.url.to_json).at_path("question/attachments/2/file/url")
      end

      it 'contains answers' do
        expect(response.body).to have_json_size(1).at_path('question/answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("question/answers/0/#{attr}")
        end
      end

    end

  end

end