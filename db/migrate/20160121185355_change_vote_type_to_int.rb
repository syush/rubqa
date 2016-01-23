class ChangeVoteTypeToInt < ActiveRecord::Migration
  def change
    remove_column :votes, :vote_value
    add_column :votes, :vote_value, :integer
  end
end
