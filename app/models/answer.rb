class Answer < ActiveRecord::Base

  include Votable
  include Attachable

  belongs_to :question
  belongs_to :user

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


end
