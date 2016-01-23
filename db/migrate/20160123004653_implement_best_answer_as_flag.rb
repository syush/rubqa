class ImplementBestAnswerAsFlag < ActiveRecord::Migration
  def change
    remove_column :questions, :best_answer_id
    add_column :answers, :best_answer, :boolean
  end
end
