require 'rails_helper'

feature 'View question with answers', %q{
        In order to read all information about a question,
        In any role,
        I can see the question and all answers on the page
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) do
    answers = []
    10.times do
      answers << create(:answer, question:question)
    end
    answers
  end

  scenario 'Guest sees a question with answers' do
    visit question_path(question)
    expect(page).to have_content(question.body)
    expect(page).to have_content(question.title)
    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end

  scenario 'Authenticated user sees a question with answers' do
    login(user)
    visit question_path(question)
    expect(page).to have_content(question.body)
    expect(page).to have_content(question.title)
    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end

end