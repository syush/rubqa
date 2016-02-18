require 'rails_helper'

RSpec.describe Answer, type: :model do

  it_behaves_like "Attachable"

  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  let(:question_author) { create(:user) }
  let(:answer_author) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user:question_author) }
  let(:answer) { create(:answer, user:answer_author, question:question) }
  let(:another_answer) { create(:answer, user:answer_author, question:question) }

  it_behaves_like "Votable" do
    let(:subject) { answer }
  end


  it 'should validate that at most one answer is best' do
    answer.set_best
    answer.save
    another_answer.set_best
    expect(another_answer).not_to be_valid
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
