require 'rails_helper'

RSpec.describe Question, type: :model do
  # it 'validates presence of title' do
  #   question = Question.new(body: '123')
  #   expect(question).not_to be_valid
  # end

  it { should validate_presence_of :title }

  it { should validate_presence_of :body }

  it { should have_many :answers }

  it { should validate_length_of(:title).is_at_most(200) }


end
