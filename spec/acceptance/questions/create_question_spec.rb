require 'rails_helper'

feature 'Create question', %q{
            In order to get an answer to a question
            As an authenticated user
            I want to be able to create a question
                         } do
  given(:user) { create(:user) }

  scenario "Authenticated user creates a question" do

    login(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question title'
    fill_in 'Text', with: 'Test question text'
    click_on 'Create'

    expect(page).to have_content 'Your question is successfully created'
    expect(page).to have_content 'Test question title'
    expect(page).to have_content 'Test question text'

  end
  scenario "Non-authenticated user tries to create a question" do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up'
    expect(current_path).to eq new_user_session_path
  end
end
