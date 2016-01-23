class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.belongs_to :user
      t.belongs_to :answer
      t.boolean :value
      t.timestamps null: false
    end
  end
end
