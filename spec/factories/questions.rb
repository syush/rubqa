FactoryGirl.define do

  factory :question do
    title "test title"
    body "test body"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end

end
