require 'rails_helper'

feature 'View questions', %q{
   In order to find information, relevant to my needs,
   As a guest,
   I can see the list of questions
} do

  given(:user) { create(:user) }
  given!(:questions) { questions = create_list(:question, 10, user:user) }

  scenario 'Guest sees the list of questions' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body[0..50])
    end
  end

  scenario 'Authenticated user sees the list of questions' do
    user = create(:user)
    login(user)
    visit questions_path
    questions.each do |question|
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body[0..50])
    end
  end

end
