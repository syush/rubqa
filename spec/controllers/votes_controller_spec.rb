require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  let(:question_author) { create(:user) }
  let(:answer_author) { create(:user) }
  let(:voter) { create(:user) }
  let(:question) { create(:question, user:question_author) }
  let!(:answer) { create(:answer, user:answer_author, question:question)}

  describe "POST #create" do

    [:question, :answer].each do |type|

      let(:votable) { type == :question ? question : answer }
      let(:votable_id) { type == :question ? :question_id : :answer_id }

      context 'legitimate_voter' do

        before { login voter }
        it 'saves new vote to DB' do
          attr = attributes_for(:vote_for)
          expect { post :create, votable_id => votable.id,
                        vote: attr, format: :js }.to change(Vote, :count).by(1)
        end

        it 'renders create template' do
          attr = attributes_for(:vote_against)
          post :create, votable_id => votable.id, vote: attr, format: :js
          expect(response).to render_template :create
        end

        it 'saves correct positive vote' do
          attr = attributes_for(:vote_for)
          post :create, votable_id => votable.id, vote: attr, format: :js
          votable.reload
          expect(votable.votes.last.vote_value).to eq 1
          expect(votable.votes.last.user_id).to eq voter.id
        end

        it 'saves correct negative vote' do
          attr = attributes_for(:vote_against)
          post :create, votable_id => votable.id, vote: attr, format: :js
          votable.reload
          expect(votable.votes.last.vote_value).to eq -1
          expect(votable.votes.last.user_id).to eq voter.id
        end

      end

      context "answer author" do

        before { login votable.user }

        it 'does not save vote to DB' do
          attr = attributes_for(:vote_for)
          expect { post :create, votable_id => votable.id,
                        vote: attr, format: :js }.not_to change(Vote, :count)
        end

      end

      context "guest" do

        it 'does not save vote to DB' do
          attr = attributes_for(:vote_against)
          expect { post :create, votable_id => votable.id,
                        vote: attr, format: :js }.not_to change(Vote, :count)
        end

      end
    end
  end

  describe "DELETE #destroy" do
    [:answer, :question].each do |type|
      let(:votable) { type == :answer ? answer : question}
      let!(:vote) { create(:vote_for, votable:votable, user:voter) }

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


end
