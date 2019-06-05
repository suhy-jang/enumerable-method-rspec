module Enumerable
  def my_each
    return (self.is_a? Enumerator) ? self : self.to_enum(:my_each) unless block_given?
    for x in self
      yield(x)
    end
  end

  def my_each_with_index
    return self.to_enum(:each_with_index) unless block_given?
    i = 0
    self.my_each do |x|
      yield(x,i)
      i += 1
    end
  end

  def my_select
    return (self.is_a? Enumerator) ? self : self.to_enum(:my_select) unless block_given?
    arr = []
    self.my_each { |p| arr << p if yield(p) }
    arr
  end

  def my_all?(pattern = nil)
    if block_given?
      self.my_each {|p| return false unless yield(p)}
    elsif pattern != nil
      if pattern.is_a? Regexp
        self.my_each {|p| return false unless pattern =~ p}
      else # sort
        self.my_each {|p| return false unless p.is_a?(pattern)}
      end
    else
      self.my_each {|p| return false unless p}
    end
    true
  end

  def my_any?(pattern = nil)
    if block_given?
      self.my_each { |p| return true if yield(p)}
    elsif pattern != nil
      if pattern.is_a? Regexp
        self.my_each {|p| return true if pattern =~ p }
      else # sort
        self.my_each { |p| return true if p.is_a?(pattern)}
      end
    else
      self.my_each { |p| return true if p }
    end
    false
  end

  def my_none?(pattern = nil)
    if block_given?
      self.my_each{ |p| return false if yield(p)}
    elsif pattern != nil
      if pattern.is_a? Regexp
        self.my_each{ |p| return false if pattern =~ p}
      else  # sort
        self.my_each{ |p| return false if p.is_a?(pattern)}
      end
    else
      self.my_each{ |p| return false if p}
    end
    true
  end

  def my_count(item = nil)
    cnt = 0
    if item.nil?
      unless block_given?
        cnt = self.length
      else
        self.my_each do |p|
          cnt += 1 if yield(p)
        end
      end
    else
      self.my_each{|p| cnt += 1 if p == item}
    end
    cnt
  end

  def my_map(proc = nil)
    return self.to_enum(:my_map) unless block_given?
    new_arr = []
    for p in self
      if !proc.nil?
        new_arr << proc.call(p)
      else
        new_arr << yield(p)
      end
    end
    new_arr
  end

  def my_inject(acc = nil)
    my_each_with_index do |p,i|
      if 0 == i && acc.nil?
        acc = p
        next
      end
      acc = yield(acc,p)
    end
    acc
  end
end

def multiply_else(arr)
  result = arr.my_inject do |memo,curr|
    memo*curr
  end
  result
end
