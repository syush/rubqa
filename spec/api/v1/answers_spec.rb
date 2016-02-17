require 'rails_helper'

RSpec.describe "Answers API" do
  describe "GET questions/:id/answers" do

    let(:user) { create(:user) }
    let!(:question) { create(:question, user:user) }

    it_behaves_like "API Authenticable" do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_author) { create(:user) }
      let(:answer_author) { create(:user) }
      let(:question) { create(:question, user:question_author) }
      let!(:answers) { create_list(:answer, 3, question:question, user:answer_author) }
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it_behaves_like "API Successful"

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

    it_behaves_like "API Authenticable" do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
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

      it_behaves_like "API Successful"

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