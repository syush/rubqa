class AddBestAnswerToQuestion < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.belongs_to :best_answer, class_name: 'Answer'
    end
  end
end
