require 'rails_helper'

feature 'Authenticated user creates an answer', %q{
  In order to share my knowledge with the community and safisfy question author's needs,
  As an authenticated user,
  I reply to an existing question
} do

  given(:user) {create(:user)}
  given(:question) { create(:question, user:user) }

  scenario 'Authenticated user replies a question', js:true do
    login(user)
    visit question_path(question)
    fill_in 'Your answer:', with: 'I guess around 7 billion'
    click_on 'Submit'
    expect(page).to have_content("I guess around 7 billion")
    expect(current_path).to eq question_path(question)
    visit question_path(question)
    expect(page).to have_content("I guess around 7 billion")
  end

  scenario 'Non-authenticated guest tries to reply a question' do
    visit question_path(question)
    expect(page).to_not have_content('Your answer:')
  end

end