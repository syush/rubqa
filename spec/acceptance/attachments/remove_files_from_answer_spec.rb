require 'rails_helper'

feature 'Remove files from answer', %q{
            As an answer author,
            In order to fix my mistake,
            I can remove a file that I added
        } do

  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:third_party) { create(:user) }
  given(:question) { create(:question, user:question_author) }

  scenario "Answer author removes one of the files he added", js:true do
    login(answer_author)
    visit question_path(question)
    fill_in 'Your answer:', with: 'My answer'
    within '.form-file-1' do
      attach_file 'File', "#{Rails.root}/Gemfile"
    end
    within '.form-file-3' do
      attach_file 'File', "#{Rails.root}/README.rdoc"
    end
    within '.new-answer-form' do
      click_on 'Submit'
    end
    within ".file-2" do
      click_on "Remove file"
    end
    expect(page).not_to have_link "Gemfile"
    expect(page).to have_link "README.rdoc"
    expect(page).to have_content 'File(s) attached:'
  end

  scenario "Answer author removes all the files he added", js:true do
    login(answer_author)
    visit question_path(question)
    fill_in 'Your answer:', with: 'My answer'
    within '.form-file-1' do
      attach_file 'File', "#{Rails.root}/Gemfile"
    end
    within '.form-file-3' do
      attach_file 'File', "#{Rails.root}/README.rdoc"
    end
    within '.form-file-2' do
      attach_file 'File', "#{Rails.root}/Rakefile"
    end
    within '.new-answer-form' do
      click_on 'Submit'
    end
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

  scenario "Non-authorized user tries to remove a file from answer", js:true do
    login(answer_author)
    visit question_path(question)
    fill_in 'Your answer:', with: 'My answer'
    within '.form-file-1' do
      attach_file 'File', "#{Rails.root}/Gemfile"
    end
    within '.new-answer-form' do
      click_on 'Submit'
    end
    click_on 'Log out'

    expect(page).to have_content "Signed out"
    visit question_path(question)
    expect(page).to have_link 'Gemfile'
    expect(page).not_to have_link 'Remove file'
  end

  scenario "Non-author tries to remove a file", js:true do
    login(answer_author)
    visit question_path(question)
    fill_in 'Your answer:', with: 'My answer'
    within '.form-file-1' do
      attach_file 'File', "#{Rails.root}/Gemfile"
    end
    within '.new-answer-form' do
      click_on 'Submit'
    end
    click_on 'Log out'
    login(third_party)
    visit question_path(question)
    expect(page).to have_link 'Gemfile'
    expect(page).not_to have_link 'Remove file'
  end

  scenario "Question author tries to remove a file from the answer", js:true do
    login(answer_author)
    visit question_path(question)
    fill_in 'Your answer:', with: 'My answer'
    within '.form-file-1' do
      attach_file 'File', "#{Rails.root}/Gemfile"
    end
    within '.new-answer-form' do
      click_on 'Submit'
    end
    click_on 'Log out'
    expect(page).to have_content "Signed out"
    login(question_author)
    visit question_path(question)
    expect(page).to have_link 'Gemfile'
    expect(page).not_to have_link 'Remove file'
  end


end