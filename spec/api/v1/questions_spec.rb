require 'rails_helper'

RSpec.describe "Questions API" do
  describe "GET /index" do

    it_behaves_like "API Authenticable" do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:questions) { create_list(:question, 2, user:user) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question:  question, user:other_user) }
      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it_behaves_like "API Successful" do
        let(:json_size) { {'questions': 2, 'questions/0/answers': 1}  }
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("questions/0/#{attr}")
        end
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("questions/0/answers/0/#{attr}")
        end
      end
    end
  end

  describe "GET /questions/:id" do

    let(:user) { create(:user) }
    let!(:question) { create(:question, user:user) }

    it_behaves_like "API Authenticable" do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
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

      it_behaves_like "API Successful" do
        let(:json_size) { {'question/attachments': 3, 'question/answers': 1} }
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("question/#{attr}")
        end
      end

      it "contains file attachments" do
        expect(response.body).to be_json_eql(attachments[0].id).at_path("question/attachments/2/id")
        expect(response.body).to be_json_eql(attachments[0].file.url.to_json).at_path("question/attachments/2/file/url")
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("question/answers/0/#{attr}")
        end
      end

    end

  end

end