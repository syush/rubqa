require 'rails_helper'

RSpec.describe Answer, type: :model do
  # it 'validates presence of title' do
  #   question = Question.new(body: '123')
  #   expect(question).not_to be_valid
  # end

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
  before do
    votes = []

    (0..6).to_a.each { |i| votes << create(:vote_for, user:voters[i], answer:answer) }
    (7..9).to_a.each { |i| votes << create(:vote_against, user:voters[i], answer:answer) }
  end

  it 'calculates voting rating' do
    expect(answer.rating).to eq 4
  end

  it 'checks whether a user has voted' do
    voters.each { |voter| expect(answer.voted(voter)).to eq true }
    expect(answer.voted(answer_author)).to eq false
    expect(answer.voted(question_author)).to eq false
    expect(answer.voted(another_user)).to eq false
  end

  it "returns user's vote" do
    (0..6).to_a.each { |i| expect(answer.get_vote(voters[i]).vote_value).to eq true }
    (7..9).to_a.each { |i| expect(answer.get_vote(voters[i]).vote_value).to eq false }
  end

end
