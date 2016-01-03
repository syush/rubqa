require 'rails_helper'

feature 'Voting', %q{
  In order to express my satisfaction or dissatisfaction with an answer,
  As an authorized user,
  I can vote for or against an answer, as well as change my opinion
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
    answers.each do |answer|
      within("#answer-#{answer.id}") do
        expect(page).not_to have_content "You dislike this answer"
        expect(page).not_to have_content "You like this answer"
        expect(page).to have_content "Rating: 0"
        expect(page).to have_link "Like"
        expect(page).to have_link "Dislike"
        expect(page).not_to have_link "Cancel vote"
      end
    end
  end

  scenario 'User votes for and against some answers', js:true do
    login another_user
    visit question_path(question)
    [1,3].each do |i|
      within "#answer-#{answers[i].id}" do
        click_on "Like"
      end
    end
    [0,4].each do |i|
      within "#answer-#{answers[i].id}" do
        click_on "Dislike"
      end
    end
    wait_for_ajax
    [1,3].each do |i|
      within "#answer-#{answers[i].id}" do
        expect(page).to have_content "You like this answer"
        expect(page).not_to have_content "You dislike this answer"
        expect(page).to have_content "Rating: 1"
        expect(page).to have_link "Cancel vote"
        expect(page).not_to have_link "Like"
        expect(page).not_to have_link "Dislike"
      end
    end
    [0,4].each do |i|
      within "#answer-#{answers[i].id}" do
        expect(page).to have_content "You dislike this answer"
        expect(page).not_to have_content "You like this answer"
        expect(page).to have_content "Rating: -1"
        expect(page).to have_link "Cancel vote"
        expect(page).not_to have_link "Like"
        expect(page).not_to have_link "Dislike"
      end
    end
    within "#answer-#{answers[2].id}" do
      expect(page).not_to have_content "You dislike this answer"
      expect(page).not_to have_content "You like this answer"
      expect(page).to have_content "Rating: 0"
      expect(page).to have_link "Like"
      expect(page).to have_link "Dislike"
      expect(page).not_to have_link "Cancel vote"
    end

  end

  scenario 'Multiple voters vote for and against an answer' do
    voters.each_with_index do |voter, i|
      login(voter)
      visit question_path(question)
      within("#answer-#{answers[2].id}") do
        click_on i % 3 == 0 ? 'Like' : 'Dislike'
      end
      click_on 'Log out'
    end
    visit question_path(question)
    within("#answer-#{answers[2].id}") do
      expect(page).to have_content "Rating: -2"
      expect(page).not_to have_link 'Like'
      expect(page).not_to have_link 'Dislike'
    end
  end

  scenario 'Question author votes for and against some answers', js:true do
    login question_author
    visit question_path(question)
    [1,3].each do |i|
      within "#answer-#{answers[i].id}" do
        click_on "Like"
      end
    end
    [0,4].each do |i|
      within "#answer-#{answers[i].id}" do
        click_on "Dislike"
      end
    end
    wait_for_ajax
    [1,3].each do |i|
      within "#answer-#{answers[i].id}" do
        expect(page).to have_content "You like this answer"
        expect(page).not_to have_content "You dislike this answer"
        expect(page).to have_content "Rating: 1"
        expect(page).to have_link "Cancel vote"
        expect(page).not_to have_link "Like"
        expect(page).not_to have_link "Dislike"
      end
    end
    [0,4].each do |i|
      within "#answer-#{answers[i].id}" do
        expect(page).to have_content "You dislike this answer"
        expect(page).not_to have_content "You like this answer"
        expect(page).to have_content "Rating: -1"
        expect(page).to have_link "Cancel vote"
        expect(page).not_to have_link "Like"
        expect(page).not_to have_link "Dislike"
      end
    end
    within "#answer-#{answers[2].id}" do
      expect(page).not_to have_content "You dislike this answer"
      expect(page).not_to have_content "You like this answer"
      expect(page).to have_content "Rating: 0"
      expect(page).to have_link "Like"
      expect(page).to have_link "Dislike"
    end
  end

  scenario 'Answer author tries to vote' do
    login(answer_authors[1])
    visit question_path(question)
    within("#answer-#{answers[0].id}") do
      expect(page).to have_link "Like"
      expect(page).to have_link "Dislike"
    end
    within("#answer-#{answers[1].id}") do
      expect(page).not_to have_link "Like"
      expect(page).not_to have_link "Dislike"
      expect(page).not_to have_link "Cancel vote"
      expect(page).not_to have_content "You dislike this answer"
      expect(page).not_to have_content "You like this answer"
    end
  end

  scenario 'Guest tries to vote' do
    visit question_path(question)
    expect(page).not_to have_link "Like"
    expect(page).not_to have_link "Dislike"
    expect(page).not_to have_link "Cancel vote"
    expect(page).not_to have_content "You dislike this answer"
    expect(page).not_to have_content "You like this answer"
    expect(page).to have_content "Rating: 0"
  end

  scenario 'Voter cancels his vote', js:true do
    login another_user
    visit question_path(question)
    within "#answer-#{answers[1].id}" do
      click_on 'Like'
    end
    wait_for_ajax
    within "#answer-#{answers[1].id}" do
      click_on 'Cancel vote'
    end
    wait_for_ajax
    within "#answer-#{answers[1].id}" do
      expect(page).not_to have_content "You dislike this answer"
      expect(page).not_to have_content "You like this answer"
      expect(page).to have_content "Rating: 0"
      expect(page).to have_link "Like"
      expect(page).to have_link "Dislike"
      expect(page).not_to have_link "Cancel vote"
    end
  end


end