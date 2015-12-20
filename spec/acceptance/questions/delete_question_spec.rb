require 'rails_helper'

feature 'Delete question', %q{
        In order to get rid of outdated information,
        As the author of a question,
        I remove my question
} do

  given(:author) { create(:user) }
  given(:question) { create(:question, user:author) }

  scenario "Question's author removes the question " do
    login(author)
    visit question_path(question)
    click_on 'Delete'
    expect(page).to have_content 'The question was successfully deleted'
    expect(page).not_to have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario "Non-author tries to remove the question" do
    non_author = create(:user)
    login(non_author)
    visit question_path(question)
    expect(page).not_to have_link 'Delete'
  end

  scenario "Non-authenticated user tries to remove the question" do
    visit question_path(question)
    expect(page).not_to have_link 'Delete'
  end
end