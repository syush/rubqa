class Vote < ActiveRecord::Base

  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, presence: true
  validates :votable_id, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  validate :forbid_own_votes

  def is_like?
    vote_value == 1
  end

  private

  def forbid_own_votes
    if self.votable && self.votable.user_id && self.user_id && self.votable.user_id == self.user_id
      errors.add(:user, 'cannot vote for or against his own votable')
    end
  end

end
