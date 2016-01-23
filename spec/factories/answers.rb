FactoryGirl.define do

  factory :answer do
    sequence :body do |n|
      "I guess something around #{6.5 + 0.05*n} billion."
    end
    best_answer false
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    best_answer false
  end

end
