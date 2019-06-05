require './lib/enumerable'

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

    it "returns itself - range" do
      expect(range.my_each{|p| p}).to eql(range.each{|p| p})
    end

    it "returns itself - array" do
      expect(array.my_each{|p| p}).to eql(array.each{|p| p})
    end

    it "returns ':method_returned'" do
     expect(enum.my_each { |elm| elm }).to eql(enum.each { |elm| elm })
    end

    it "returns the enumerator of the receiver - enum" do
      expect(enum.my_each).to be_an Enumerator
    end

    it "returns the enumerator of the receiver - range" do
      expect(range.my_each).to be_an Enumerator
    end

    it "returns the enumerator of the receiver - array" do
      expect(array.my_each).to be_an Enumerator
    end
  end

  describe "#my_each_with_index" do
    animals = %w(cat dog wombat)

    it "returns itself with block and two arguments" do
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
    array_num = [1,2,3,4,5]
    array_sym = [:foo, :bar]

    it "returns an array of the results with range input" do
      expect(range.my_select{|p| p % 3 == 0 }).to eql(range.select{|p| p % 3 == 0 })
    end

    it "returns an array of the results with number array input" do
      expect(array_num.my_select { |p| p.even? })
      .to eql(array_num.select { |p| p.even? } )
    end

    it "returns an array of the results with symbol array input" do
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
      expect(array_num.my_select).to be_an Enumerator
    end
  end

  describe "#my_all?" do
    animals = %w[ant bear cat]

    it "returns true or false with given block" do
      expect(animals.my_all? { |word| word.length >= 4 })
      .to eql(animals.all? { |word| word.length >= 4 })
    end

    regexp = /w/
    it "returns true or false matching with given pattern - Regexp class" do
      expect(animals.my_all?(regexp)).to eql(animals.all?(regexp))
    end

    arr = [1, 2i, 3.14]
    it "returns true or false matching with given pattern - general classes" do
      expect(arr.my_all?(Numeric)).to eql(arr.all?(Numeric)) # true
    end

    arr = [nil, true, 99]
    it "returns true or false for that all elements is true in the #{arr}" do
      expect(arr.my_all?).to eql(arr.all?) # false
    end

    arr = []
    it "returns true or false for that all elements is true in the #{arr}" do
      expect(arr.my_all?).to eql(arr.all?) # true
    end
  end

  describe "#my_any?" do
    animals = %w[ant bear cat]

    it "returns true or false with given block" do
      expect(animals.my_any? {|word| word.length >= 4})
      .to eql(animals.any? {|word| word.length >= 4} )
    end

    regexp = /t/
    it "returns true or false matching with given pattern - Regexp" do
      expect(animals.my_any? (regexp)).to eql(animals.any? (regexp))
    end

    arr = [nil, true, 99]
    it "returns true or false for that any of elements is true for #{arr}" do
      expect(arr.my_any?).to eql(arr.any?)
    end

    arr = []
    it "returns true or false for that any of elements is true for #{arr}" do
      expect(arr.my_any?).to eql(arr.any?)
    end
  end

  describe "#my_none?" do
    animals = %w{ant bear cat}

    it "returns true or false with given block" do
      expect(animals.my_none? { |word| word.length >= 4 })
      .to eql(animals.none? { |word| word.length >= 4 })
    end

    regexp = /d/
    it "returns true or false matching with given pattern - Regexp" do
      expect(animals.my_none?(regexp)).to eql(animals.none?(regexp))
    end

    arr = [1, 3.14, 42]
    general_class = Float

    it "returns true or false matching with given pattern - general_class" do
      expect(arr.my_none?(general_class)).to eql(arr.none?(general_class))
    end

    arr = [nil, false]
    it "returns true or false without pattern or block given for #{arr}" do
      expect(arr.my_none?).to eql(arr.none?) # true
    end

    arr = [nil, false, true]
    it "returns true or false without pattern or block given for #{arr}" do
      expect(arr.my_none?).to eql(arr.none?) # false
    end
  end

  describe "#my_count" do
    arr = [1, 2, 4, 2]

    it "returns the number of the elements without block or pattern given" do
      expect(arr.my_count).to eql(arr.count) # 4
    end

    it "returns the number of the elements matching with given pattern" do
      expect(arr.my_count(2)).to eql(arr.count(2)) # 2
    end

    it "returns the number of the elements matching with given block" do
      expect(arr.my_count{|x| x%2 == 0 }).to eql(arr.count{|x| x%2 == 0 })
    end
  end

  describe "#my_map" do
    range = (1..4)

    it "returns a new array through the given block process" do
      expect(range.my_map{ |x| x*x }).to eql(range.map{ |x| x*x })
    end

    it "returns an enumerator if no block is given" do
      expect(range.my_map).to be_an Enumerator
    end
  end

  describe "#my_inject" do
    range = (5..10)

    it "returns accumulated result without parameter" do
      expect(range.my_inject { |acc,n| acc+n }).to eql(range.inject { |acc,n| acc+n }) # 45
    end

    it "returns accumulated result with parameter" do
      accumulator = 2
      expect(range.my_inject(accumulator) { |acc,n| acc*n })
      .to eql(range.inject(accumulator) { |acc,n| acc*n }) #151200*2
    end
  end
end
