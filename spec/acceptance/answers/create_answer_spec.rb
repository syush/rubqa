require 'rails_helper'

feature 'Authenticated user creates an answer', %q{
  In order to share my knowledge with the community and safisfy question author's needs,
  As an authenticated user,
  I reply to an existing question
} do

  given(:user) {create(:user)}
  given(:question) { create(:question, user:user) }

  scenario 'Authenticated user replies a question' do
    login(user)
    visit question_path(question)
    click_on 'Reply'
    fill_in 'Your answer:', with: 'I guess around 7 billion'
    click_on 'Submit'
    expect(page).to have_content("I guess around 7 billion")
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated guest tries to reply a question' do
    visit question_path(question)
    click_on 'Reply'
    expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
    expect(page).to_not have_content('Your answer:')
  end

end