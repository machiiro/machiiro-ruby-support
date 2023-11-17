RSpec.describe Array do
  it "to_h_key" do
    array = [ { id: 1, name: 'a' }, { id: 2, name: 'b' }, { id: 3, name: 'c' } ]
    hash = array.to_h_key(:id)

    expect(hash.keys).to eq([1, 2, 3])
    expect(hash.values).to eq([array[0], array[1], array[2]])

    test_class = Struct.new(:id, :value)
    array = [test_class.new(1, 'test 1'), test_class.new(2, 'test 2'), test_class.new(3, 'test 3')]
    hash = array.to_h_key(:id)
    expect(hash.keys).to eq([1, 2, 3])
    expect(hash.values).to eq([array[0], array[1], array[2]])
  end
end
