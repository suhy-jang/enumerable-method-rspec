require './lib/enumerable'

RSpec.describe Enumerable do
  let(:sample_arr) { ["apple", "orange", "banana", "pear"]}
  describe "#my_each" do
    it "returns the array" do
      arr = [1,2,3,4]
      expect(arr.my_each{|p| p}).to eql(arr.each{|p| p})
    end

    it "returns the enumerator of the receiver" do
      arr = [1,2,3,4]
      expect(arr.my_each).to be_an Enumerator
      expect(arr.my_each.to_a).to eql(arr.each.to_a)
    end
  end

  describe "#my_select" do
    it "returns a new array with all the numbers what is smaller than 5 of the receiver." do
      arr = [2,4,6,8]
      expect(arr.my_select{|p| p < 5 }).to eql(arr.select{|p| p < 5 })
    end

    it "returns a new array with all the numbers is even" do
      arr = [1,2,3,4,5]
      expect(arr.my_select { |p| p.even? }).to eql(arr.select { |p| p.even? } )
    end
  end

  describe "#my_all?" do
    it "returns true or false with all the numbers is even" do
      arr = [2,4,6,8,12]
      expect(arr.my_all? { |p| p.even? }).to eql(arr.all? { |p| p.even? })
    end

    it "returns true or false with all the numbers is Numeric" do
      arr = [1, 2i, 3.14]
      expect(arr.my_all?(Numeric)).to eql(arr.all?(Numeric))
    end

    it "returns true or false with all the numbers is Numeric" do
      arr = [nil, true, 99]
      expect(arr.my_all?).to eql(arr.all?)
    end

    it "returns true or false with all the numbers is Numeric" do
      arr = []
      expect(arr.my_all?).to eql(arr.all?)
    end
  end

  describe "#my_any?" do
    arr_make = %w[ant bear cat]
    it "returns true or false with any the words is longer or equal than 4 in #{arr_make}" do
      expect(arr_make.my_any? {|word| word.length >= 4})
      .to eql(arr_make.any? {|word| word.length >= 3} )
    end
    arr = [nil, true, 99]
    it "returns true or false with any input is not [0-9a-zA-Z_] in #{arr}" do
      expect(arr.my_any?(/w/)).to eql(arr.any?(/w/))
    end
    arr = []
    it "returns true or false with any input is in #{arr}" do
      expect(arr.my_any?).to eql(arr.any?)
    end
  end

  describe "#my_none?" do
    arr_make = %w{ant bear cat}
    it "returns my none" do
      expect(arr_make.my_none? { |word| word.length >= 4 })
      .to eql(arr_make.none? { |word| word.length >= 4 })
    end
    arr = [nil, false]
    it "returns true or false with 'none' input is in #{arr}" do
      expect(arr.my_none?).to eql(arr.none?) # true
    end
  end

  describe "#my_count" do
    arr = [1, 2, 4, 2]
    it "returns the number of the elements is in the #{arr}" do
      expect(arr.my_count).to eql(arr.count) # 4
    end

    # pattern given
    it "returns the number of the elements '2' in the #{arr}" do
      expect(arr.my_count).to eql(arr.count) # 2
    end

    # block given
    it "returns the number of the even number elements in the #{arr}" do
      expect(arr.my_count{|x| x%2 == 0 }).to eql(arr.count{|x| x%2 == 0 })
    end
  end

  describe "#my_map" do
    range = (1..4)
    it "returns the array what has exponential elements for the #{range}" do
      expect(range.my_map{ |x| x*x }).to eql(range.map{ |x| x*x })
    end

    it "returns the array in the #{range}" do
      expect(range.my_map).to be_an Enumerator
    end
  end

  describe "#my_inject" do
    range = (5..10)
    it "returns the accumulation in the given condition (with no accumulator)" do
      expect(range.my_inject { |acc,n| acc+n })
      .to eql(range.inject { |acc,n| acc+n }) # 45
    end

    it "returns the accumulation in the given condition (with accumulator)" do
      expect(range.my_inject(2) { |acc,n| acc*n })
      .to eql(range.inject(2) { |acc,n| acc*n }) #151200*2
    end
  end
end
