require 'rails_helper'

RSpec.describe Answer, type: :model do

  it_behaves_like "Attachable"

  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:voters).through(:votes).source(:user) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  let(:question_author) { create(:user) }
  let(:answer_author) { create(:user) }
  let(:voters) { create_list(:user, 10) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user:question_author) }
  let(:answer) { create(:answer, user:answer_author, question:question) }
  let(:another_answer) { create(:answer, user:answer_author, question:question) }
  before do
    votes = []
    (0..6).to_a.each { |i| votes << create(:vote_for, user:voters[i], answer:answer) }
    (7..9).to_a.each { |i| votes << create(:vote_against, user:voters[i], answer:answer) }
  end

  it 'should validate that at most one answer is best' do
    answer.set_best
    answer.save
    another_answer.set_best
    expect(another_answer).not_to be_valid
  end

  it 'calculates voting rating' do
    expect(answer.rating).to eq 4
  end

  it 'correctly treats integer vote values as likes and dislikes' do
    expect(answer.get_vote(voters[5]).is_like?).to eq true
    expect(answer.get_vote(voters[8]).is_like?).to eq false
  end

  it 'checks whether a user has voted' do
    voters.each { |voter| expect(answer.voted?(voter)).to eq true }
    expect(answer.voted?(answer_author)).to eq false
    expect(answer.voted?(question_author)).to eq false
    expect(answer.voted?(another_user)).to eq false
  end

  it "returns user's vote" do
    (0..6).to_a.each { |i| expect(answer.get_vote(voters[i]).vote_value).to eq 1 }
    (7..9).to_a.each { |i| expect(answer.get_vote(voters[i]).vote_value).to eq -1 }
  end

  it 'sets best answer' do
    answer.set_best
    expect(answer.is_best?).to be_truthy
  end

  it 'resets best answer' do
    answer.set_best
    answer.reset_best
    expect(answer.is_best?).to be_falsey
  end

end
