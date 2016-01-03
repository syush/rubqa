require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  let(:question_author) { create(:user) }
  let(:answer_author) { create(:user) }
  let(:voter) { create(:user) }
  let(:question) { create(:question, user:question_author) }
  let!(:answer) { create(:answer, user:answer_author, question:question)}

  describe "POST #create" do

    context 'legitimate_voter' do

      before { login voter }

      it 'saves new vote to DB' do
        attr = attributes_for(:vote_for)
        expect { post :create, answer_id: answer.id,
                      vote: attr, format: :js }.to change(Vote, :count).by(1)
      end

      it 'renders create template' do
        attr = attributes_for(:vote_against)
        post :create, answer_id: answer.id, vote: attr, format: :js
        expect(response).to render_template :create
      end

      it 'saves correct positive vote' do
        attr = attributes_for(:vote_for)
        post :create, answer_id: answer.id, vote: attr, format: :js
        answer.reload
        expect(answer.votes.last.vote_value).to eq true
        expect(answer.votes.last.user_id).to eq voter.id
      end

      it 'saves correct negative vote' do
        attr = attributes_for(:vote_against)
        post :create, answer_id: answer.id, vote: attr, format: :js
        answer.reload
        expect(answer.votes.last.vote_value).to eq false
        expect(answer.votes.last.user_id).to eq voter.id
      end

    end

    context "answer author" do

      before { login answer_author }

      it 'does not save vote to DB' do
        attr = attributes_for(:vote_for)
        expect { post :create, answer_id: answer.id,
                      vote: attr, format: :js }.not_to change(Vote, :count)
      end

    end

    context "guest" do

      it 'does not save vote to DB' do
        attr = attributes_for(:vote_against)
        expect { post :create, answer_id: answer.id,
                      vote: attr, format: :js }.not_to change(Vote, :count)
      end

    end

  end

  describe "DELETE #destroy" do
    let!(:vote) { create(:vote_for, answer:answer, user:voter) }

    context 'voter' do
      before { login voter }

      it 'deletes vote from DB' do
        expect { delete :destroy, id: vote.id, format: :js }.to change(Vote, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, id: vote, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'non-voter' do
      it 'does not delete the vote from DB' do
        non_voter = create(:user)
        login(non_voter)
        expect { delete :destroy, id: vote, format: :js }.not_to change(Vote, :count)
      end

    end

    context 'guest' do
      it 'does not delete the vote from DB' do
        expect { delete :destroy, id: vote, format: :js }.not_to change(Vote, :count)
      end
    end

  end


end
