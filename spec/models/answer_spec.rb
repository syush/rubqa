require 'rails_helper'

RSpec.describe Answer, type: :model do
  # it 'validates presence of title' do
  #   question = Question.new(body: '123')
  #   expect(question).not_to be_valid
  # end

  it { should belong_to :question }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }


end
