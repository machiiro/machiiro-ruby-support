RSpec.describe Array do
  it "to_h_key" do
    array = [ { id: 1, name: 'a' }, { id: 2, name: 'b' }, { id: 3, name: 'c' } ]
    hash = array.to_h_key(:id)

    expect(hash.keys).to eq([1, 2, 3])
  end
end
