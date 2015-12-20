require 'rails_helper'

feature 'Edit question', %q{
          In order to update the question with more precise data,
          As the question's author,
          I can edit the question
        } do

  given(:author) { create(:user) }
  given(:question) { create(:question, user:author) }
  given(:non_author) { create(:user) }
  given!(:answer) { create(:answer, question:question, user:non_author)}

  scenario 'Question author edits the question' do
    login(author)
    visit question_path(question)
    click_on 'Edit question'
    fill_in 'Title', with: 'First man in the outer space'
    fill_in 'Text', with: 'Who was the first man to fly in the outer space?'
    click_on 'Submit'
    expect(page).to have_content 'First man in the outer space'
    expect(page).to have_content 'Who was the first man to fly in the outer space?'
    expect(page).to have_content answer.body
    expect(page).not_to have_content question.title
    expect(page).not_to have_content question.body
    expect(page).to have_content 'Your question was successfully updated'
  end

  scenario 'Non-author tries to edit the question'  do
    login(non_author)
    visit question_path(question)
    expect(page).not_to have_link 'Edit question'
  end

  scenario 'A guest tries to edit a question' do
    visit question_path(question)
    expect(page).not_to have_link 'Edit question'
  end
end

