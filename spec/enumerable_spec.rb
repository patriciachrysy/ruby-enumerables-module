require './enumerables'

describe Enumerable do
    let(:arr) {[1, 2, 3, 4, 5]}
    let(:string_arr) {['cat', 'mouse', 'hamster', 'dog', 'duck']}
    let(:hash) {{one:1, two:2, three:3, four:4, five:5}}
    let(:range) {(1..5)}
    let(:result) {[]}
    let(:my_hash) {{}}
    describe '#my_each' do
        it 'Applies the function in the block to the enumerable which calls it' do
            arr.my_each{|i| result << i*2}
            expect(result).to eql([2, 4, 6, 8, 10])
        end

        it 'Return an enumerable when no block is passed to the function' do
            expect(range.my_each).not_to eql(arr)
        end
    end

    describe '#my_each_with_index' do
        it 'Applies the function in the block to the indexes of the enumerable which calls it' do
           string_arr.my_each_with_index{|value, index| my_hash[value.to_sym]=index }
           expect(my_hash).to eql({cat:0, mouse:1, hamster:2, dog:3, duck:4})
        end

        it 'Return an enumerable when no block is passed to the function' do
            expect(hash.my_each).not_to eql(hash)
        end
    end

    describe '#my_select' do
        it 'Selects elements from an enumerable according to a given block' do
            expect(hash.my_select{|key, value| value.even?}).to eq({two:2, four:4})
        end

        it 'Returns an empty array if none of the values meets the condtions passed in the block' do
            evens = arr.my_select{|item| item.even?}
            expect(evens.my_select{|item| item.odd?}.length).not_to eql(1)
        end
    end

    describe '#my_all?' do
        it 'Return true if all the elements in the enumerables match the condition in the block' do
            expect(range.my_all?{|item| item < 100}).to eql(true)
        end

        it 'Returns false if one of the elements in the enumerable does not match the parameter passed to the function' do
            expect(arr.my_all?(&:even?)).not_to eql(true)
        end
    end

    describe '#my_any?' do
        it 'Return true if at least one element in the enumerables matches the condition in the block' do
            expect(range.my_any?{|item| item%3 == 0 }).to eql(true)
        end

        it 'Returns false if none of the elements in the enumerable matches the parameter passed to the function' do
            expect(string_arr.my_any?(Numeric)).not_to eql(true)
        end
    end

    
end