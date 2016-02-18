require 'rails_helper'

feature 'Question voting', %q{
  In order to express my satisfaction or dissatisfaction with a question,
  As an authorized user,
  I can vote for or against a question, as well as change my opinion
} do


  given(:question_author) { create(:user) }
  given(:answer_authors) { create_list(:user, 5) }
  given(:voters) { create_list(:user, 10) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user:question_author) }

  given!(:answers) do
    answers = []
    answer_authors.each { |author| answers << create(:answer, question:question, user:author) }
    answers
  end

  scenario 'User is able to vote' do
    login another_user
    visit question_path(question)
    within(".question-votes") do
      expect(page).not_to have_content "You dislike this question"
      expect(page).not_to have_content "You like this question"
      expect(page).to have_content "Rating: 0"
      expect(page).to have_button "Like"
      expect(page).to have_button "Dislike"
      expect(page).not_to have_link "Cancel vote"
    end
  end

  scenario 'User votes for the question', js:true do
    login another_user
    visit question_path(question)
    within ".question-votes" do
      click_on "Like"
    end
    wait_for_ajax
    within ".question-votes" do
      expect(page).to have_content "You like this question"
      expect(page).not_to have_content "You dislike this question"
      expect(page).to have_content "Rating: 1"
      expect(page).to have_link "Cancel vote"
      expect(page).not_to have_button "Like"
      expect(page).not_to have_button "Dislike"
    end
  end

  scenario 'User votes against the question', js:true do
    login another_user
    visit question_path(question)
    within ".question-votes" do
      click_on "Dislike"
    end
    wait_for_ajax
    within ".question-votes" do
      expect(page).not_to have_content "You like this question"
      expect(page).to have_content "You dislike this question"
      expect(page).to have_content "Rating: -1"
      expect(page).to have_link "Cancel vote"
      expect(page).not_to have_button "Like"
      expect(page).not_to have_button "Dislike"
    end
  end


  scenario 'Multiple voters vote for and against the question', js:true do
    voters.each_with_index do |voter, i|
      login(voter)
      visit question_path(question)
      within(".question-votes") do
        click_on i % 3 == 0 ? 'Like' : 'Dislike'
      end
      click_on 'Log out'
    end
    visit question_path(question)
    within(".question-votes") do
      expect(page).to have_content "Rating: -2"
      expect(page).not_to have_button 'Like'
      expect(page).not_to have_button 'Dislike'
    end
  end

  scenario 'Answer author votes for the question', js:true do
    login answer_authors[2]
    visit question_path(question)
    within ".question-votes" do
      click_on "Like"
    end
    wait_for_ajax
    within ".question-votes" do
      expect(page).to have_content "You like this question"
      expect(page).not_to have_content "You dislike this question"
      expect(page).to have_content "Rating: 1"
      expect(page).to have_link "Cancel vote"
      expect(page).not_to have_button "Like"
      expect(page).not_to have_button "Dislike"
    end
  end

  scenario 'Question author tries to vote' do
    login(question_author)
    visit question_path(question)
    within(".question-votes") do
      expect(page).not_to have_button "Like"
      expect(page).not_to have_button "Dislike"
      expect(page).not_to have_link "Cancel vote"
      expect(page).not_to have_content "You dislike this question"
      expect(page).not_to have_content "You like this question"
    end
  end

  scenario 'Guest tries to vote' do
    visit question_path(question)
    expect(page).not_to have_button "Like"
    expect(page).not_to have_button "Dislike"
    expect(page).not_to have_link "Cancel vote"
    expect(page).not_to have_content "You dislike this question"
    expect(page).not_to have_content "You like this question"
    within(".question-votes") do
      expect(page).to have_content "Rating: 0"
    end
  end

  scenario 'Voter cancels his vote and votes again', js:true do
    login another_user
    visit question_path(question)
    within ".question-votes" do
      click_on 'Like'
    end
    wait_for_ajax
    within ".question-votes" do
      click_on 'Cancel vote'
    end
    wait_for_ajax
    within ".question-votes" do
      expect(page).not_to have_content "You dislike this question"
      expect(page).not_to have_content "You like this question"
      expect(page).to have_content "Rating: 0"
      expect(page).to have_button "Like"
      expect(page).to have_button "Dislike"
      expect(page).not_to have_link "Cancel vote"
      click_on 'Like'
      expect(page).not_to have_content "You dislike this question"
      expect(page).to have_content "You like this question"
      expect(page).to have_content "Rating: 1"
      expect(page).not_to have_button "Like"
      expect(page).not_to have_button "Dislike"
      expect(page).to have_link "Cancel vote"
    end

  end


end