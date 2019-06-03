module Enumerable
  def my_each
    return self.to_enum(:my_each) unless block_given?
    for i in self
      yield(i)
    end
  end

  def my_each_with_index
    for i in 0...self.length
      yield(self[i],i)
    end
  end

  def my_select
    arr=[]
    self.my_each { |p| arr << p if yield(p) }
    arr
  end

  def my_all?(pattern=nil)
    if block_given?
      self.my_each {|p| return false unless yield(p)}
    elsif !pattern.nil?
      self.my_each {|p| return false unless p.is_a?(pattern)}
    else
      self.my_each {|p| return false unless p}
    end
    true
  end

  def my_any?(pattern=nil)
    if block_given?
      self.my_each { |p| return true if yield(p)}
    elsif !pattern.nil?
      self.my_each { |p| return true if p.is_a?(pattern)}
    else
      self.my_each { |p| return true if p }
    end
    false
  end

  def my_none?(pattern=nil)
    if block_given?
      self.my_each{ |p| return false if yield(p)}
    elsif !pattern.nil?
      self.my_each{ |p| return false if p.is_a?(pattern)}
    else
      self.my_each{ |p| return false if p}
    end
    true
  end

  def my_count(item=nil)
    cnt=0
    if item.nil?
      unless block_given?
        cnt = self.length
      else
        self.my_each do |p|
          cnt+=1 if yield(p)
        end
      end
    else
      self.my_each{|p| cnt+=1 if p==item}
    end
    cnt
  end

  def my_map(proc=nil)
    return self.to_enum(:my_each) unless block_given?
    new_arr=[]
    for p in self
      if !proc.nil?
        new_arr << proc.call(p)
      else
        new_arr << yield(p)
      end
    end
    new_arr
  end

  def my_inject(acc=nil)
    i=0
    for p in self
      if 0==i && acc.nil?
        acc = p
        i+=1
        next
      end
      acc = yield(acc,p)
      i+=1
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
