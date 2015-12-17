class AddFieldsToQuestionsAndAnswers < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.string :body
      t.string :title
    end
    change_table :answers do |t|
      t.string :body
    end
  end
end
