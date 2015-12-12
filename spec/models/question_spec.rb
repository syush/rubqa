require 'rails_helper'

RSpec.describe Question, type: :model do
  # it 'validates presence of title' do
  #   question = Question.new(body: '123')
  #   expect(question).not_to be_valid
  # end

  it { should validate_presence_of :title }

  it { should validate_presence_of :body }

  it { should have_many :answers }

  it 'should allow 200 or less characters in title' do
    question = Question.new
    question.body = "test for short title"
    question.title = 'X' * 200
    expect(question).to be_valid
  end

  it 'should not allow >200 characters iin title' do
    question = Question.new
    question.body = "test for long title"
    question.title = 'X' * 201
    expect(question).not_to be_valid
  end


end
