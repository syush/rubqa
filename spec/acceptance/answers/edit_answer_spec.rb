require 'rails_helper'

feature 'Edit answer', %q{
   In order to make the answer more clear and precise,
   As the author of an answer,
   I can edit the answer
} do

  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:third_party) { create(:user) }
  given(:question) { create(:question, user:question_author)}
  given!(:some_answers) { create_list(:answer, 3, question:question, user:third_party) }
  given!(:answer_to_edit) { create(:answer, question:question, user:answer_author) }
  given!(:some_more_answers) { create_list(:answer, 3, question:question, user:third_party) }
  given!(:another_answer) { create(:answer, question:question, user:answer_author) }

  scenario 'Author edits their answer', js:true do
    login(answer_author)
    visit question_path(question)
    within("#answer-#{answer_to_edit.id}") do
      click_on 'Edit answer'
    end
    fill_in 'Your answer:', with: "I don't know"
    click_on 'Submit'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content "I don't know"
    expect(page).not_to have_content answer_to_edit.body
    (some_answers + some_more_answers << another_answer).each do |answer|
      expect(page).to have_content answer.body
    end
    expect(page).to have_content('Your answer:')
    expect(current_path).to eq question_path(question)
  end

  scenario 'Author edits an answer trying to make it invalid', js:true do
    login(answer_author)
    visit question_path(question)
    within("#answer-#{answer_to_edit.id}") do
      click_on 'Edit answer'
    end
    fill_in 'Your answer:', with: ''
    click_on 'Submit'
    expect(page).to have_content "Body can't be blank"
    within("#answer-#{answer_to_edit.id}") do
      expect(page).to have_css "form"
    end
  end

  scenario 'Author starts editing an answer and then cancels editing', js:true do
    login(answer_author)
    visit question_path(question)
    within("#answer-#{answer_to_edit.id}") do
      click_on 'Edit answer'
    end
    fill_in 'Your answer:', with: 'hmmm...'
    click_on 'Cancel'
    expect(page).to have_content answer_to_edit.body
    within("#answer-#{answer_to_edit.id}") do
      expect(page).not_to have_css "form"
    end
    expect(page).to have_content('Your answer:')
  end

  scenario 'User adds an answer and edits it without page reload', js:true do
    login(third_party)
    visit question_path(question)
    fill_in 'Your answer:', with: 'bad answer'
    click_on 'Submit'
    wait_for_ajax
    within all('.answer').last do
      click_on 'Edit answer'
    end
    fill_in 'Your answer:', with: 'good answer'
    click_on 'Submit'
    wait_for_ajax
    expect(page).to have_content 'good answer'
    expect(page).not_to have_content 'bad answer'
    (some_answers + some_more_answers << another_answer << answer_to_edit).each do |answer|
      expect(page).to have_content(answer.body)
    end
  end

  scenario 'Question author tries to edit an answer' do
    login(question_author)
    visit question_path(question)
    within("#answer-#{answer_to_edit.id}") do
      expect(page).not_to have_link 'Edit answer'
    end
  end

  scenario 'Third party tries to edit an answer' do
    login(third_party)
    visit question_path(question)
    within("#answer-#{answer_to_edit.id}") do
      expect(page).not_to have_link 'Edit answer'
    end
  end

  scenario 'Unauthenticated user tries to edit an answer' do
    visit question_path(question)
    within("#answer-#{answer_to_edit.id}") do
      expect(page).not_to have_link 'Edit answer'
    end
  end

end