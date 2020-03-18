require './enumerables'

describe Enumerable do
  let(:arr) { [1, 2, 3, 4, 5] }
  let(:string_arr) { %w[cat mouse hamster dog duck] }
  let(:hash) { { one: 1, two: 2, three: 3, four: 4, five: 5 } }
  let(:range) { (1..5) }
  let(:result) { [] }
  let(:my_hash) { {} }
  describe '#my_each' do
    it 'Applies the function in the block to the enumerable which calls it' do
      arr.my_each { |i| result << i * 2 }
      expect(result).to eql([2, 4, 6, 8, 10])
    end

    it 'Return an enumerable when no block is passed to the function' do
      expect(range.my_each).not_to eql(arr)
    end
  end

  describe '#my_each_with_index' do
    it 'Applies the function in the block to the indexes of the enumerable which calls it' do
      string_arr.my_each_with_index { |value, index| my_hash[value.to_sym] = index }
      expect(my_hash).to eql({ cat: 0, mouse: 1, hamster: 2, dog: 3, duck: 4 })
    end

    it 'Return an enumerable when no block is passed to the function' do
      expect(hash.my_each).not_to eql(hash)
    end
  end

  describe '#my_select' do
    it 'Selects elements from an enumerable according to a given block' do
      expect(hash.my_select { |_key, value| value.even? }).to eq({ two: 2, four: 4 })
    end

    it 'Returns an empty array if none of the values meets the condtions passed in the block' do
      evens = arr.my_select { |item| item % 3 == 0 }
      expect(evens.my_select { |item| item % 3 != 0 }.length).not_to eql(1)
    end
  end

  describe '#my_all?' do
    it 'Return true if all the elements in the enumerables match the condition in the block' do
      expect(range.my_all? { |item| item < 100 }).to eql(true)
    end

    it 'Returns false if one of the elements in the enumerable does not match the parameter passed to the function' do
      expect(arr.my_all?(&:even?)).not_to eql(true)
    end
  end

  describe '#my_any?' do
    it 'Return true if at least one element in the enumerables matches the condition in the block' do
      expect(range.my_any? { |item| item % 3 == 0 }).to eql(true)
    end

    it 'Returns false if none of the elements in the enumerable matches the parameter passed to the function' do
      expect(string_arr.my_any?(Numeric)).not_to eql(true)
    end
  end

  describe '#my_none?' do
    it 'Returns true if none of elements in the enumerables matches the condition in the block' do
      expect(range.my_none? { |item| item == 0 }).to eql(true)
    end
    it 'Returns false if at least one element in the enumerables matches the parameter' do
      expect(range.my_none?(Integer)).not_to eql(true)
    end
  end
  describe '#my_count' do
    it 'Returns the number of elements that match the condition in the block' do
      expect(arr.my_count { |element| element > 2 }).to eql(3)
    end
    it 'Returns the number of elements in enumerables when no block and no parameter is passed' do
      expect(hash.my_count).to eql(5)
    end
    it 'Returns zero when no element matches the parameter' do
      expect(arr.my_count(6)).not_to eql(1)
    end
  end
  describe '#my_map' do
    it 'Applies the function in the block to each element in the enumerable' do
      expect(range.my_map { |item| item**2 }).to eql([1, 4, 9, 16, 25])
    end
    it 'Applies the function in the proc passed in parameter to every element of the enumerables' do
      my_proc = proc { |num| num + num }
      expect(range.my_map(my_proc)).not_to eql(range)
    end
  end
  describe '#my_inject' do
    it 'Applies the operator passed in parameter to all the values of the enumerables' do
      expect(arr.my_inject(:+)).to eql(15)
    end
    it 'Applies the function passed in the block to all the elements of the enumerables' do
      expect(string_arr.my_inject { |memo, item| memo.length > item.length ? memo : item }).to eql('hamster')
    end
    it 'Concatenate the enumerable values and the first parameter using the operator passed in parameter' do
      expect(arr.my_inject(10, :+)).not_to eql(15)
    end
    it 'Applies the function in the block to all the elements of the enumerables starting from the parameter' do
      expect(arr.my_inject(10) { |memo, item| memo >= item ? memo : item }).not_to eql(5)
    end
  end
  describe '#multiply_els' do
    it 'Multiplies all the elements in the enumerables passed in parameter and returns the result' do
      expect(multiply_els(arr)).to eql(120)
    end
  end
end
