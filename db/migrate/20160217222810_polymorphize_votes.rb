class PolymorphizeVotes < ActiveRecord::Migration
  def change
    remove_column :votes, :answer_id
    add_reference :votes, :votable, polymorphic: true
  end
end
