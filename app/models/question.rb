class Question < ActiveRecord::Base

  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer'
  belongs_to :user

  validates :user_id, presence: true
  validates :title, :body, presence:true
  validates :title, :length => { :maximum => 200 }

end
