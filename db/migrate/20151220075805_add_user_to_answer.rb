class AddUserToAnswer < ActiveRecord::Migration
  def change
    change_table :answers do |t|
      t.belongs_to :user
    end
  end
end
