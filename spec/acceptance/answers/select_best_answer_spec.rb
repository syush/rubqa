require 'rails_helper'

def select_as_best(candidate)
  within("#answer-#{candidate.id}") do
    click_on 'Select as best answer'
  end
end

def expect_to_see_selection(best_answer, non_best_answers)
  within :css, ("#answers > :first-child") do
    expect(page).to have_content best_answer.body
    expect(page).to have_content 'Best answer'
    expect(page).not_to have_link 'Select as best answer'
  end
  non_best_answers.each do |answer|
    within("#answer-#{answer.id}") do
      expect(page).not_to have_content 'Best answer'
      expect(page).to have_content answer.body
    end
  end
end


feature 'Select best answer', %q{
   In order to express the satisfaction with an answer,
   As the author of the question,
   I can declare an answer as the best answer
} do

  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:third_party) { create(:user) }
  given(:question) { create(:question, user:question_author)}
  given!(:some_answers) { create_list(:answer, 3, question:question, user:third_party) }
  given!(:candidate_to_best) { create(:answer, question:question, user:answer_author) }
  given!(:some_more_answers) { create_list(:answer, 3, question:question, user:third_party) }
  given!(:another_answer) { create(:answer, question:question, user:answer_author) }
  given!(:non_best_answers) { some_answers + some_more_answers + [another_answer] }

  context 'Question author' do

    background do
      login question_author
      visit question_path(question)
    end

    scenario 'Question author selects the best answer and sees the result', js:true do
      select_as_best candidate_to_best
      expect_to_see_selection(candidate_to_best, non_best_answers)
    end

    scenario 'Question author selects the best answer and other users see the result', js:true do
      select_as_best candidate_to_best
      click_on 'Log out'
      login third_party
      visit question_path(question)
      expect_to_see_selection(candidate_to_best, non_best_answers)
    end

    scenario 'Question author changes its initial choice and sees the result', js:true do
      select_as_best another_answer
      select_as_best candidate_to_best
      expect_to_see_selection(candidate_to_best, non_best_answers)
    end

    scenario 'Question author changes its initial choice and answer author sees the result', js:true do
      select_as_best another_answer
      select_as_best candidate_to_best
      click_on 'Log out'
      login(answer_author)
      visit question_path(question)
      expect_to_see_selection(candidate_to_best, non_best_answers)
    end

    scenario 'Question author selects the best answer, and answer author can not change the selection', js:true do
      select_as_best candidate_to_best
      click_on 'Log out'
      login answer_author
      visit question_path(question)
      expect(page).not_to have_content 'Select as best answer'
    end

    scenario 'Question author repeatedly selects the same best answer', js:true do
      select_as_best candidate_to_best
      select_as_best another_answer
      select_as_best candidate_to_best
      expect_to_see_selection(candidate_to_best, non_best_answers)
    end

  end

  scenario 'Non-author of the question tries to select the best answer' do
    login(third_party)
    visit question_path(question)
    expect(page).not_to have_link 'Select as best answer'
  end

  scenario 'Non-registered user tries to select best answer' do
    visit question_path(question)
    expect(page).not_to have_link 'Select as best answer'
  end


end

