shared_examples_for "API Successful" do


  it 'returns 200 status' do
    expect(response).to be_success
  end



end