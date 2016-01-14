require 'rails_helper'

  RSpec.describe QuestionsController, type: :controller do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user:user) }

    describe "GET #index" do
      before { get :index }

      it 'loads all questions' do
        questions = create_list(:question, 3, user:user)
        expect(assigns(:questions)).to eq questions
      end

      it 'renders index template' do
        expect(response).to render_template :index
      end
    end

    describe "GET #show" do
      before { get :show, id: question }

      it 'loads question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders show template' do
        expect(response).to render_template :show
      end
    end

    describe "GET #new" do
      before do
        login(user)
        get :new
      end

      it 'assigns new Question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders show template' do
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do

      before { login(user) }

      context 'valid' do
        it 'saves new question in DB' do
          expect { post :create,
                   question: attributes_for(:question) }.to change(Question, :count).by(1)
        end

        it 'links the question with the current user' do
          post :create, question: attributes_for(:question)
          question = Question.last
          expect(question.user).to eq user
        end

        it 'redirects to show' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context 'invalid' do
        it 'does not save new question in DB' do
          expect { post :create,
                   question: attributes_for(:invalid_question) }.to_not change(Question, :count)
        end

        it 'renders show template' do
          post :create, question: attributes_for(:invalid_question)
          expect(response).to render_template :new
        end
      end
    end

    describe "PATCH #update" do

      context 'valid' do
        before do
          login(user)
          patch :update, id: question, question: { title: 'new title', body: 'new body' }
        end

        it 'changes question' do
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'renders JSON with question'

      end

      context 'invalid' do
        before do
          login(user)
          patch :update, id: question, question: { title: nil, body: nil }
        end

        it 'does not change question attributes' do
          old_title = question.title
          old_body = question.body
          question.reload
          expect(question.title).to eq old_title
          expect(question.body).to eq old_body
        end

        it 'renders JSON with errors'

      end

      context 'non_author' do
        before do
          login(other_user)
          patch :update, id: question, question: { title: 'new title', body: 'new body'}
        end

        it 'does not change question attributes' do
          old_title = question.title
          old_body = question.body
          question.reload
          expect(question.title).to eq old_title
          expect(question.body).to eq old_body
        end

      end

      context 'guest' do
        before do
          patch :update, id: question, question: { title: 'new title', body: 'new body'}
        end

        it 'does not change question attributes' do
          old_title = question.title
          old_body = question.body
          question.reload
          expect(question.title).to eq old_title
          expect(question.body).to eq old_body
        end

      end


    end

    describe "DELETE #destroy" do

      before { question }

      context 'author' do
        before { login(user) }

        it 'deletes question from DB' do
          expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, id: question
          expect(response).to redirect_to questions_path
        end
      end

      context 'non-author' do
        before do
          non_author = create(:user)
          login(non_author)
        end

        it 'does not delete the question from DB' do
          expect { delete :destroy, id: question }.not_to change(Question, :count)
        end
      end

      context 'guest' do
        it 'does not delete the question from DB' do
          expect { delete :destroy, id: question }.not_to change(Question, :count)
        end
      end

    end
end
