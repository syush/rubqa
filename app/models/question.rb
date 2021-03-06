class Question < ActiveRecord::Base

  include Votable
  include Attachable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :user_id, presence: true
  validates :title, :body, presence:true
  validates :title, :length => { :maximum => 200 }


  def best_answer
    self.answers.where(best_answer: true).first
  end

  def set_best_answer_and_save(answer)
    old_best = self.best_answer
    old_best.try(:reset_best)
    answer.set_best
    success = !old_best || old_best.save
    success &&= answer.save
  end

  def sorted_answers
    self.answers.order(:best_answer).reverse_order
  end

end
