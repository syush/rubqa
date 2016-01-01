require 'rails_helper'

RSpec.describe Question, type: :model do
  # it 'validates presence of title' do
  #   question = Question.new(body: '123')
  #   expect(question).not_to be_valid
  # end

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:best_answer).class_name('Answer').dependent(:destroy) }
  it { should belong_to :user }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_most(200) }

end
