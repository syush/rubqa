FactoryGirl.define do


  factory :vote_for, class: 'Vote' do
    vote_value 1
  end

  factory :vote_against, class: 'Vote' do
    vote_value -1
  end

end
