require 'rails_helper'

RSpec.describe Vote, type: :model do

  it { should belong_to :answer }
  it { should belong_to :user }

  it { should validate_uniqueness_of(:answer_id).scoped_to(:user_id) }

end