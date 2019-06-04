require './enumerable'

RSpec.describe Enumerable do
  let(:enum) {
    obj = Object.new

    def obj.each_arg(a, b=:b, *rest)
      yield a
      yield b
      yield rest
      :method_returned
    end

    enum = obj.to_enum :each_arg, :a, :x
  }

  describe "#my_each" do
    range = (1..4)
    array = [:a, :x, []]
    it "returns the enumerator of the receiver - enum" do
      expect(enum.my_each).to be_an Enumerator
    end

    it "returns the enumerator of the receiver - range" do
      expect(range.my_each).to be_an Enumerator
    end

    it "returns the enumerator of the receiver - array" do
      expect(array.my_each).to be_an Enumerator
    end

    it "returns itself - enum" do
      expect(enum.my_each).to eql(enum.each)
    end

    it "returns itself - range" do
      expect(range.my_each{|p| p}).to eql(range.each{|p| p})
    end

    it "returns itself - array" do
      expect(array.my_each{|p| p}).to eql(array.each{|p| p})
    end

    it "returns ':method_returned'" do
     expect(enum.my_each { |elm| elm }).to eql(enum.each { |elm| elm })
    end
  end

  describe "#my_each_with_index" do
    animals = %w(cat dog wombat)
    it "returns an enumerator if block with two arguments are given" do
      hash = Hash.new
      expect(animals.my_each_with_index{|item,index| hash[item] = index})
      .to eql(animals.each_with_index{|item,index| hash[item] = index})
    end

    it "returns an enumerator if no block is given" do
      expect(animals.my_each_with_index).to be_an Enumerator
    end
  end

  describe "#my_select" do
    range = (1..10)
    array = [1,2,3,4,5]
    array_sym = [:foo, :bar]

    it "returns an array containing 3 divisable elements only - range input" do
      expect(range.my_select{|p| p % 3 == 0 }).to eql(range.select{|p| p % 3 == 0 })
    end

    it "returns an array containing even numbers only - array input" do
      expect(array.my_select { |p| p.even? }).to eql(array.select { |p| p.even? } )
    end

    it "returns an array containing specific symbols only - symbol array input" do
      expect(array_sym.my_select { |p| p == :foo })
      .to eql(array_sym.select { |p| p == :foo } )
    end

    it "returns the enumerator of the receiver - Enum" do
      expect(enum.my_select).to be_an Enumerator
    end

    it "returns the enumerator of the receiver - Range" do
      expect(range.my_select).to be_an Enumerator
    end

    it "returns the enumerator of the receiver - Array" do
      expect(array.my_select).to be_an Enumerator
    end
  end

  describe "#my_all?" do
    it "returns true or false with every words are longer or equal than 4" do
      animals = %w[ant bear cat]
      expect(animals.my_all? { |word| word.length >= 4 })
      .to eql(animals.all? { |word| word.length >= 4 })
    end

    # it "returns true or false with all elements is between [0-9a-zA-Z_]" do
    #   expect(animals.my_all?(/w/)).to eql(animals.all?(/w/))
    # end

    it "returns true or false with all the numbers is Numeric" do
      arr = [1, 2i, 3.14]
      expect(arr.my_all?(Numeric)).to eql(arr.all?(Numeric)) # true
    end

    it "returns true or false with all the numbers is Numeric" do
      arr = [nil, true, 99]
      expect(arr.my_all?).to eql(arr.all?) # false
    end

    it "returns true or false with all the numbers is Numeric" do
      arr = []
      expect(arr.my_all?).to eql(arr.all?) # true
    end
  end

  describe "#my_any?" do
    # it "returns true or false with every words have tap" do
    #   expect(animals.my_all? (/t/)).to eql(animals.all? (/t/))
    # end
    # animals = %w[ant bear cat]
    # it "returns true or false with any words is longer or equal than 4 in #{animals}" do
    #   expect(animals.my_any? {|word| word.length >= 4})
    #   .to eql(animals.any? {|word| word.length >= 4} )
    # end
    # arr = [nil, true, 99]
    # it "returns true or false with any input is not [0-9a-zA-Z_] in #{arr}" do
    #   expect(arr.my_any?(/w/)).to eql(arr.any?(/w/))
    # end
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
