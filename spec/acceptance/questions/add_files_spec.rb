require 'rails_helper'

feature 'Add files to question', %q{
        In order to support the question with data,
        As the author of a question,
        I can add a file to the question during question creation
      } do

  given(:user) { create(:user) }

  scenario 'Question author adds a file during question creation' do
    login(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'How about adding a file?'
    attach_file 'File', "#{Rails.root}/Gemfile"
    click_on 'Submit'
    expect(page).to have_link "Gemfile"
  end

end