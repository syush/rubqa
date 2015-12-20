require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question_author) { create(:user) }
  let(:answer_author) { create(:user) }
  let(:question) { create(:question, user:question_author) }

  before { login(answer_author) }

  describe "GET #new" do

    before { get :new, question_id: question.id }

    it 'assigns new Answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show template' do
      expect(response).to render_template :new
    end

    it 'assigns new answer to the right question' do
      expect(assigns(:question).id).to eq question.id
    end

  end

  describe "POST #create" do
    context 'valid' do
      it 'saves new question in DB' do
        attr = attributes_for(:answer)
        expect { post :create, question_id: question.id, answer: attr }.to change(Answer, :count).by(1)
      end

      it 'redirects to show' do
        attr = attributes_for(:answer)
        post :create, question_id: question.id, answer: attr
        expect(response).to redirect_to question_path(question)
      end

      it 'saves the correct text' do
        attr = attributes_for(:answer)
        post :create, question_id: question.id, answer: attr
        answered_question = Question.find(question.id)
        expect(answered_question.answers.first.body).to eq attr[:body]
      end

      it 'links with the correct question' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        answered_question = Question.find(question.id)
        expect(answered_question.answers.first.question.id).to eq question.id
      end

      it 'assigns the correct author' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        answered_question = Question.find(question.id)
        expect(answered_question.answers.first.user.id).to eq answer_author.id
      end

    end

    context 'invalid' do
      it 'does not save new answer in DB' do
        attr = attributes_for(:invalid_answer)
        answer = build(:invalid_answer)
        expect { post :create, question_id: question.id, answer: attr }.to_not change(Answer, :count)
      end

      it 'renders new template' do
        attr = attributes_for(:invalid_answer)
        post :create, question_id: question.id, answer: attr
        expect(response).to render_template :new
      end
    end
  end


end
