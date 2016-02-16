require 'rails_helper'

feature 'Add files to question', %q{
        In order to support the question with data,
        As the author of a question,
        I can add a file to the question during question creation
      } do

  given(:user) { create(:user) }

  scenario 'Question author adds a couple of files during question creation' do
    login(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'How about adding a file?'
    within '.form-file-1' do
      attach_file 'File', "#{Rails.root}/Gemfile"
    end
    within '.form-file-3' do
      attach_file 'File', "#{Rails.root}/README.rdoc"
    end
    click_on 'Submit'
    expect(page).to have_link "Gemfile"
    expect(page).to have_link "README.rdoc"
    expect(page).to have_content "File(s) attached:"
  end

  scenario 'User creates a question without files' do
    login(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'How about adding a file?'
    click_on  'Submit'
    expect(page).not_to have_content "File(s) attached:"
  end

end