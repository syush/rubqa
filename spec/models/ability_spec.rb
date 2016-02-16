require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject { Ability.new(user) }
  describe 'for guest' do
    let(:user) { nil }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should_not be_able_to :manage, Question }
    it { should_not be_able_to :manage, Answer}
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }
    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:yet_another) { create(:user) }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :update, create(:question, user: user) }
    it { should be_able_to :update, create(:answer, user: user, question: create(:question, user:user)) }
    it { should_not be_able_to  :update, create(:question, user: other) }
    it { should_not be_able_to :update, create(:answer, user: other, question: create(:question, user:user)) }
    it { should be_able_to :destroy, create(:question, user: user) }
    it { should be_able_to :destroy, create(:answer, user: user, question: create(:question, user:user)) }
    it { should_not be_able_to  :destroy, create(:question, user: other) }
    it { should_not be_able_to :destroy, create(:answer, user: other, question: create(:question, user:user)) }
    it { should be_able_to :create, Vote }
    it { should be_able_to :destroy, create(:vote_for, user: user, answer:
                                   create(:answer, user:other, question:create(:question, user:yet_another))) }
    it { should_not be_able_to :destroy, create(:vote_for, user: other, answer:
                                   create(:answer, user: yet_another, question:create(:question, user:user))) }
    it { should be_able_to :select_as_best, create(:answer, user:other, question: create(:question, user:user)) }
    it { should_not be_able_to :select_as_best, create(:answer, user:other, question: create(:question, user:yet_another)) }
  end
end