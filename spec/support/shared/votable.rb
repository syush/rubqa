shared_examples_for "Votable" do

  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:voters).through(:votes).source(:user) }

  let(:voters) { create_list(:user, 10) }
  let(:non_voters) { create_list(:user, 4) }

  before do
    votes = []
    (0..6).to_a.each { |i| votes << create(:vote_for, user:voters[i], votable:subject) }
    (7..9).to_a.each { |i| votes << create(:vote_against, user:voters[i], votable:subject) }
  end


  it 'calculates voting rating' do
    expect(subject.rating).to eq 4
  end

  it 'correctly treats integer vote values as likes and dislikes' do
    expect(subject.get_vote(voters[5]).is_like?).to eq true
    expect(subject.get_vote(voters[8]).is_like?).to eq false
  end

  it 'checks whether a user has voted' do
    voters.each { |voter| expect(subject.voted?(voter)).to eq true }
    non_voters.each { |user| expect(subject.voted?(user)).to eq false }
    expect(subject.voted?(subject.user)).to eq false
  end

  it "returns user's vote" do
    (0..6).to_a.each { |i| expect(subject.get_vote(voters[i]).vote_value).to eq 1 }
    (7..9).to_a.each { |i| expect(subject.get_vote(voters[i]).vote_value).to eq -1 }
  end


end