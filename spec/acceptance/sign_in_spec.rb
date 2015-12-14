require 'rails_helper'

  feature 'Signing in', %q{
        In order to be able to ask questions
        As a guest
        I want to be able to sign in
  } do
     scenario 'Existing user tries to sign in' do
       User.create(email: 'user@test.com', password: '12345678')
       visit new_user_session_path
       fill_in 'Email', with: 'user@test.com'
       fill_in 'Password', with: '12345678'
       click_on 'Sign in'
       expect(page).to have_content 'Signed in successfully'
       expect(page).to have_link 'Sign out'
     end
     scenario 'Non-existing user tries to sign in' do
       visit new_user_session_path
       fill_in 'Email', with: 'user@test.com'
       fill_in 'Password', with: '12345678'
       click_on 'Sign in'
       expect(page).to have_content 'Invalid login or password'
       expect(page).to_not have_link 'Sign out'
     end
  end