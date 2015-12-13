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
        attr[:question_id] = @question.id
        expect { post :create, question_id: @question.id, answer: attr }.to change(Answer, :count).by(1)
      end

      it 'redirects to show' do
        attr = FactoryGirl.attributes_for(:answer)
        attr[:question_id] = @question.id
        post :create, question_id: @question.id, answer: attr
        expect(response).to redirect_to question_path(@question)
      end
    end

    context 'invalid' do
      it 'does not save new answer in DB' do
        attr = FactoryGirl.attributes_for(:invalid_answer)
        attr[:question_id] = @question.id
        answer = FactoryGirl.build(:invalid_answer)
        expect { post :create, question_id: @question.id, answer: attr }.to_not change(Answer, :count)
      end

      it 'renders new template' do
        attr = FactoryGirl.attributes_for(:invalid_answer)
        attr[:question_id] = @question.id
        post :create, question_id: @question.id, answer: attr
        expect(response).to render_template :new
      end
    end
  end


end
