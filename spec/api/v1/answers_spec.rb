require 'rails_helper'

RSpec.describe "Answers API" do
  describe "GET questions/:id/answers" do

    let(:user) { create(:user) }
    let!(:question) { create(:question, user:user) }
    context "unauthorized" do
      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end


    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_author) { create(:user) }
      let(:answer_author) { create(:user) }
      let(:question) { create(:question, user:question_author) }
      let!(:answers) { create_list(:answer, 3, question:question, user:answer_author) }
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(3).at_path('answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answers[0].send(attr).to_json).at_path("answers/0/#{attr}")
        end
      end

    end

  end

  describe "GET questions/:id/answer/:id" do

    let(:question_author) { create(:user) }
    let(:answer_author) { create(:user) }
    let(:question) { create(:question, user:question_author) }
    let!(:answer) { create(:answer, question:question, user:answer_author)}
    context "unauthorized" do
      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end


    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_author) { create(:user) }
      let(:answer_author) { create(:user) }
      let(:question) { create(:question, user:question_author) }
      let(:answers) { create_list(:answer, 3, question:question, user:answer_author) }
      let(:answer) { answers.first }
      let!(:attachments) { create_list(:attachment, 3, attachable:answer)}
      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("answer/#{attr}")
        end
      end

      it "answer contains attachment" do
        expect(response.body).to be_json_eql(answer.attachments[1].id.to_json).at_path("answer/attachments/1/id")
        expect(response.body).to be_json_eql(answer.attachments[1].file.url.to_json).at_path("answer/attachments/1/file/url")
      end

    end

  end


end