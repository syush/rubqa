require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  before do
    @question = FactoryGirl.create(:question)
  end

  describe "GET #new" do
    before do
      get :new, question_id: @question.id
    end

    it 'assigns new Answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show template' do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context 'valid' do
      it 'saves new question in DB' do
        attr = FactoryGirl.attributes_for(:answer)
        expect { post :create, question_id: @question.id, answer: attr }.to change(Answer, :count).by(1)
      end

      it 'redirects to show' do
        attr = FactoryGirl.attributes_for(:answer)
        post :create, question_id: @question.id, answer: attr
        expect(response).to redirect_to question_path(@question)
      end

      it 'links with the correct question' do
        attr = FactoryGirl.attributes_for(:answer)
        post :create, question_id: @question.id, answer: attr
        @question = Question.find(@question.id)
        expect(@question.answers.first.body).to eq attr[:body]
        expect(@question.answers.first.question.id).to eq @question.id
      end


    end

    context 'invalid' do
      it 'does not save new answer in DB' do
        attr = attributes_for(:invalid_answer)
        answer = build(:invalid_answer)
        expect { post :create, question_id: @question.id, answer: attr }.to_not change(Answer, :count)
      end

      it 'renders new template' do
        attr = attributes_for(:invalid_answer)
        post :create, question_id: @question.id, answer: attr
        expect(response).to render_template :new
      end
    end
  end


end
