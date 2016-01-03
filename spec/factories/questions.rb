FactoryGirl.define do


  factory :question do
    sequence :title do |n|
      "World population in #{n+2000}"
    end

    sequence :body do |n|
      "What #{ n < 2015 ? "was" : "will" } the world population #{ "be " if n >= 2015 }in #{n+2000}?"
    end

    best_answer nil

  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end

end
