require 'rails_helper'

RSpec.describe Question, type: :model do
  # it 'validates presence of title' do
  #   question = Question.new(body: '123')
  #   expect(question).not_to be_valid
  # end

  it_behaves_like "Attachable"

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_most(200) }

  let(:question_author) { create(:user) }
  let(:answer_author) { create(:user) }
  let(:question) { create(:question, user:question_author) }
  let!(:answers) { create_list(:answer, 3, question:question, user:answer_author)}

  it 'returns absence of best answer' do
    expect(question.best_answer).to be_nil
  end

  it 'returns best answer' do
    question.set_best_answer_and_save(answers[1])
    expect(question.reload.best_answer.id).to eq answers[1].id
  end

  context 'change best answer' do

    before do
      question.set_best_answer_and_save(answers[1])
      question.set_best_answer_and_save(answers[2])
    end

    it 'sets the best answer attribute of the new best answer' do
      expect(answers[2].reload.is_best?).to be_truthy
    end

    it 'resets the best answer attribute of the old best answer' do
      expect(answers[1].reload.is_best?).to be_falsey
    end

    it 'changes the best answer selection' do
      expect(question.reload.best_answer.id).to eq answers[2].id
    end

  end

end

