class Answer < ActiveRecord::Base

  belongs_to :question
  belongs_to :user
  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user

  validates :body, presence:true
  validates :question_id, presence:true
  validates :user_id, presence:true
  validates :best_answer, uniqueness: { scope: :question_id }, if: :best_answer

  def is_best?
    self.best_answer
  end

  def set_best
    self.best_answer = true
  end

  def reset_best
    self.best_answer = false
  end

  def rating
    self.votes.sum(:vote_value)
  end

  def voted?(user)
    voters.include?(user)
  end

  def get_vote(user)
#    Vote.where("answer_id = ? and user_id = ?", self.id, user.id)
    self.votes.where(user_id: user.id).first
  end

end
