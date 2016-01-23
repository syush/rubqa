class RenameVoteValue < ActiveRecord::Migration
  def change
    rename_column :votes, :value, :vote_value
  end
end
