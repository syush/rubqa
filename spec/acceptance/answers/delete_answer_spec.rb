require 'rails_helper'

feature 'Delete answer', %q{
   Due to realizing that the given answer was incorrect or imprecise,
   As the author of the answer,
   I can delete my answer
} do

  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:third_party) { create(:user) }
  given(:question) { create(:question, user:question_author) }
  given!(:some_answers) { create_list(:answer, 3, question:question, user:third_party) }
  given!(:answer_to_delete) { create(:answer, question:question, user:answer_author) }
  given!(:some_more_answers) { create_list(:answer, 3, question:question, user:third_party) }
  given!(:another_answer) { create(:answer, question:question, user:answer_author) }

  scenario 'Author deletes their answer' do
    login(answer_author)
    visit question_path(question)
    within('#answer-3') { click_on 'Delete answer' }
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    (some_answers + some_more_answers + another_answer).each do |answer|
      expect(page).to have_content(answer.body)
    end
    expect(page).not_to have_content(answer_to_delete).body
  end

  scenario 'Question author tries to delete the answer'
  scenario 'Third party tries to delete the answer'
  scenario 'Unauthenticated user tries to delete an answer'

end