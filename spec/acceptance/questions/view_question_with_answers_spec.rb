require 'rails_helper'

def check_question_page(question, answers)
  visit question_path(question)
  expect(page).to have_content(question.body)
  expect(page).to have_content(question.title)
  answers.each do |answer|
    expect(page).to have_content(answer.body)
  end
end

feature 'View question with answers', %q{
        In order to read all information about a question,
        In any role,
        I can see the question and all answers on the page
} do

  given!(:question_author) { create(:user) }
  given!(:answer_author) { create(:user) }
  given!(:third_party) { create(:user) }
  given!(:question) { create(:question, user: question_author) }
  given!(:answers) { create_list(:answer, 10, question:question, user:answer_author) }

  scenario 'Guest sees a question with answers' do
    check_question_page(question, answers)
  end

  scenario 'Question author sees a question with answers' do
    login(question_author)
    check_question_page(question, answers)
  end

  scenario 'Answer author sees a question with answers' do
    login(answer_author)
    check_question_page(question, answers)
  end

  scenario 'Third party sees a question with answers' do
    login(third_party)
    check_question_page(question, answers)
  end

end