require 'rails_helper'

feature 'Logging out', %q{
        In order to prevent another person from using my session
        As a signed-in user
        I want to be able to log out
  } do

  given!(:user) { create(:user) }
  scenario 'User logs out' do
    login(user)
    visit questions_path
    click_on 'Log out'
    expect(page).to have_link 'Sign in'
    expect(page).not_to have_link 'Log out'
  end
end