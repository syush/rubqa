class AddIndexToVotes < ActiveRecord::Migration
  def change
    add_index "votes", ["votable_id", "votable_type"], name: "index_votes_on_votable_id_and_votable_type", using: :btree
  end
end
