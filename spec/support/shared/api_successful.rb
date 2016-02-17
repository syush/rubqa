shared_examples_for "API Successful" do


  it 'returns 200 status' do
    expect(response).to be_success
  end

  it 'returns JSON of correct size' do
    if defined? json_size
      json_size.each do |path, size|
        expect(response.body).to have_json_size(size).at_path(path.to_s)
      end
    end
  end

end