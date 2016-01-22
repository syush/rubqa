class Vote < ActiveRecord::Base

  belongs_to :user
  belongs_to :answer

  validates :user_id, presence: true
  validates :answer_id, presence: true
  validates :user_id, uniqueness: { scope: :answer_id }

  validate :forbid_own_votes

  def is_like?
    vote_value == 1
  end

  private

  def not_own_question
    self.answer.user_id != self.user_id
  end

  def forbid_own_votes
    if self.answer && self.answer.user_id && self.user_id && self.answer.user_id == self.user_id
      errors.add(:user, 'cannot vote for or against his own answer')
    end
  end

end
