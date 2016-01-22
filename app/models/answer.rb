class Answer < ActiveRecord::Base

  belongs_to :question
  belongs_to :user
  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user

  validates :body, presence:true
  validates :question_id, presence:true
  validates :user_id, presence:true

  def rating
    self.votes.sum(:vote_value)
  end

  def voted?(user)
    voters.include?(user)
  end

  def get_vote(user)
    votes.each { |v| return v if user.id == v.user_id }
  end

end
