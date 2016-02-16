require 'rails_helper'

feature 'Remove files from question', %q{
            As a question author,
            In order to fix my mistake,
            I can remove a file that I added
        } do

  given(:author) { create(:user) }
  given(:non_author) { create(:user) }

  scenario "Question author removes one of the files he added" do
    login(author)
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
    within ".file-2" do
      click_on "Remove file"
    end
    expect(page).not_to have_link "Gemfile"
    expect(page).to have_link "README.rdoc"
    expect(page).to have_content 'File(s) attached:'
  end

  scenario "Question author removes all the files he added" do
    login(author)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'How about adding a file?'
    within '.form-file-1' do
      attach_file 'File', "#{Rails.root}/Gemfile"
    end
    within '.form-file-3' do
      attach_file 'File', "#{Rails.root}/README.rdoc"
    end
    within '.form-file-2' do
      attach_file 'File', "#{Rails.root}/Rakefile"
    end
    click_on 'Submit'
    within ".file-2" do
      click_on "Remove file"
    end
    within ".file-2" do
      click_on "Remove file"
    end
    within ".file-1" do
      click_on "Remove file"
    end
    expect(page).not_to have_link "Gemfile"
    expect(page).not_to have_link "README.rdoc"
    expect(page).not_to have_link "Rakefile"
    expect(page).not_to have_content 'File(s) attached:'
  end

  scenario "Non-authorized user tries to remove a file" do
    login(author)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'How about adding a file?'
    within '.form-file-1' do
      attach_file 'File', "#{Rails.root}/Gemfile"
    end
    click_on 'Submit'
    click_on 'Log out'
    click_on 'Test question'
    expect(page).to have_link 'Gemfile'
    expect(page).not_to have_link 'Remove file'
  end

  scenario "Non-author tries to remove a file" do
    login(author)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'How about adding a file?'
    within '.form-file-1' do
      attach_file 'File', "#{Rails.root}/Gemfile"
    end
    click_on 'Submit'
    click_on 'Log out'
    login(non_author)
    click_on 'Test question'
    expect(page).to have_link 'Gemfile'
    expect(page).not_to have_link 'Remove file'
  end

end