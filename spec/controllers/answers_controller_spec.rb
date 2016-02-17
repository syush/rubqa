require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question_author) { create(:user) }
  let(:answer_author) { create(:user) }
  let(:question) { create(:question, user:question_author) }

  describe "POST #create" do

    before { login(answer_author) }

    context 'valid' do
      it 'saves new question in DB' do
        attr = attributes_for(:answer)
        expect { post :create, question_id: question.id,
                      answer: attr, format: :js }.to change(Answer, :count).by(1)
      end

      it 'renders create template' do
        attr = attributes_for(:answer)
        post :create, question_id: question.id, answer: attr, format: :js
        expect(response).to render_template :create
      end

      it 'saves the correct text' do
        attr = attributes_for(:answer)
        post :create, question_id: question.id, answer: attr, format: :js
        answered_question = Question.find(question.id)
        expect(answered_question.answers.first.body).to eq attr[:body]
      end

      it 'links with the correct question' do
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
        answered_question = Question.find(question.id)
        expect(answered_question.answers.first.question.id).to eq question.id
      end

      it 'assigns the correct author' do
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
        answered_question = Question.find(question.id)
        expect(answered_question.answers.first.user.id).to eq answer_author.id
      end

    end

    context 'invalid' do
      it 'does not save new answer in DB' do
        attr = attributes_for(:invalid_answer)
        answer = build(:invalid_answer)
        expect { post :create, question_id: question.id,
                      answer: attr, format: :js }.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        attr = attributes_for(:invalid_answer)
        post :create, question_id: question.id, answer: attr, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe "PATCH #update" do

    let(:answer) { create(:answer, question:question, user:answer_author) }

    context 'valid' do
      before do
        login(answer_author)
        patch :update, id: answer, answer: { body: 'No idea' }
      end

      it 'changes answer' do
        answer.reload
        expect(answer.body).to eq 'No idea'
      end

      it 'renders question with updated answer in JSON'

    end

    context 'invalid' do
      before do
        login(answer_author)
        patch :update, id: answer, answer: { body: nil }
      end

      it 'does not change answer' do
        old_body = answer.body
        answer.reload
        expect(answer.body).to eq old_body
      end

      it 'renders question with non-updated answer in JSON'

    end

    context 'non-author' do
      before do
        login(question_author)
        patch :update, id: answer, answer: { body: 'No idea' }
      end

      it 'does not change answer' do
        old_body = answer.body
        answer.reload
        expect(answer.body).to eq old_body
      end
    end

    context 'guest' do
      before { patch :update, id: answer, answer: { body: 'No idea' } }

      it 'does not change answer' do
        old_body = answer.body
        answer.reload
        expect(answer.body).to eq old_body
      end
    end

    context 'private_pub' do
      it 'sends PrivatePub message' do
        expect(PrivatePub).to receive(:publish_to).with("/questions/#{answer.question.id}/answers",
                                                        answer: answer, action:'update')
        login(answer_author)
        patch :update, id: answer, answer: { body: 'No idea' }
      end
    end
  end

  describe "DELETE #destroy" do

    let!(:answer) { create(:answer, question:question, user:answer_author) }

    context 'author' do
      before { login(answer_author) }

      it 'deletes answer from DB' do
        expect { delete :destroy, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'non-author' do
      it 'does not delete the answer from DB' do
        non_author = create(:user)
        login(non_author)
        expect { delete :destroy, id: answer, format: :js }.not_to change(Answer, :count)
      end

    end

    context 'guest' do
      it 'does not delete the answer from DB' do
        expect { delete :destroy, id: answer, format: :js }.not_to change(Answer, :count)
      end
    end

  end

  describe "GET #select_as_best" do

    let!(:answers) { create_list(:answer, 3, question:question, user:answer_author) }

    before { question.set_best_answer_and_save(answers[1]) }

    context 'question-author' do

      before do
        login(question_author)
        xhr :get, :select_as_best, id:answers[2], format: :js
      end

      it 'makes the answer best' do
        expect(question.reload.best_answer.id).to eq answers[2].id
      end

      it 'renders select_as_best template' do
        expect(response).to render_template :select_as_best
      end

    end

    context 'non-author' do
      it 'does not change best answer selection' do
        login(answer_author)
        xhr :get, :select_as_best, id:answers[2], format: :js
        question.reload
        expect(question.best_answer.id).to eq answers[1].id
      end
    end

    context 'guest' do
      it 'does not change best answer selection' do
        xhr :get, :select_as_best, id:answers[2], format: :js
        question.reload
        expect(question.best_answer.id).to eq answers[1].id
      end
    end
  end

end
