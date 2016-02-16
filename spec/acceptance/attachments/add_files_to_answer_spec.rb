require 'rails_helper'

feature 'Add files to answer', %q{
        In order to support the answer with data,
        As the author of an answer,
        I can add files to the answer during answer creation
      } do

  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:question) { create(:question, user:question_author) }

  scenario 'Answer author adds a couple of files during answer creation', js:true do
    login(answer_author)
    visit question_path(question)
    fill_in 'Your answer:', with: 'My answer'
    within '.form-file-1' do
      attach_file 'File', "#{Rails.root}/Gemfile"
    end
    within '.form-file-3' do
      attach_file 'File', "#{Rails.root}/README.rdoc"
    end
    within ".new-answer-form" do
      click_on 'Submit'
    end
    expect(page).to have_link "Gemfile"
    expect(page).to have_link "README.rdoc"
    expect(page).to have_content "File(s) attached:"
  end

  scenario 'User creates an answer without files', js:true do
    login(answer_author)
    visit question_path(question)
    fill_in 'Your answer:', with: 'My answer'
    within ".new-answer-form" do
      click_on 'Submit'
    end
    expect(page).to have_content "My answer"
    expect(page).not_to have_content "File(s) attached:"
  end

end