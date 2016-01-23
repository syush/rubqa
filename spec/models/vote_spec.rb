require 'rails_helper'

RSpec.describe Vote, type: :model do

  it { should belong_to :answer }
  it { should belong_to :user }

  it { should validate_presence_of :answer_id }
  it { should validate_presence_of :user_id }

  it { should validate_uniqueness_of(:user_id).scoped_to(:answer_id) }

  it 'does not allow to vote for own answer' do
    question_author, answer_author = create_list(:user, 2)
    question = create(:question, user:question_author)
    answer = create(:answer, user:answer_author, question:question)
    vote = build(:vote_for, user:answer_author, answer:answer)
    expect(vote).not_to be_valid
  end

end