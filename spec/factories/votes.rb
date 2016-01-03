FactoryGirl.define do


  factory :vote_for, class: 'Vote' do
    vote_value true
  end

  factory :vote_against, class: 'Vote' do
    vote_value false
  end

end
