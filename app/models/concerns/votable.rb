module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
    has_many :voters, through: :votes, source: :user
  end

  def rating
    self.votes.sum(:vote_value)
  end

  def voted?(user)
    voters.include?(user)
  end

  def get_vote(user)
    self.votes.where(user_id: user.id).first
  end


end