# frozen_string_literal: true

module Enumerable
  def my_each
    return (is_a? Enumerator) ? self : to_enum(:my_each) unless block_given?

    each do |x|
      yield(x)
    end
  end

  def my_each_with_index
    return to_enum(:each_with_index) unless block_given?

    i = 0
    my_each do |x|
      yield(x, i)
      i += 1
    end
  end

  def my_select
    return (is_a? Enumerator) ? self : to_enum(:my_select) unless block_given?

    arr = []
    my_each { |p| arr << p if yield(p) }
    arr
  end

  def my_all?(pattern = nil)
    if block_given?
      my_each { |p| return false unless yield(p) }
    elsif !pattern.nil?
      if pattern.is_a? Regexp
        my_each { |p| return false unless pattern =~ p }
      else # sort
        my_each { |p| return false unless p.is_a?(pattern) }
      end
    else
      my_each { |p| return false unless p }
    end
    true
  end

  def my_any?(pattern = nil)
    if block_given?
      my_each { |p| return true if yield(p) }
    elsif !pattern.nil?
      if pattern.is_a? Regexp
        my_each { |p| return true if pattern =~ p }
      else # sort
        my_each { |p| return true if p.is_a?(pattern) }
      end
    else
      my_each { |p| return true if p }
    end
    false
  end

  def my_none?(pattern = nil)
    if block_given?
      my_each { |p| return false if yield(p) }
    elsif !pattern.nil?
      if pattern.is_a? Regexp
        my_each { |p| return false if pattern =~ p }
      else # sort
        my_each { |p| return false if p.is_a?(pattern) }
      end
    else
      my_each { |p| return false if p }
    end
    true
  end

  def my_count(item = nil)
    cnt = 0
    if item.nil?
      my_each do |p|
        next if block_given? && !yield(p)

        cnt += 1
      end
    else
      my_each { |p| cnt += 1 if p == item }
    end
    cnt
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given?

    new_arr = []
    my_each do |p|
      new_arr << if !proc.nil?
                   proc.call(p)
                 else
                   yield(p)
                 end
    end
    new_arr
  end

  def my_inject(acc = nil)
    my_each_with_index do |p, i|
      if i == 0 && acc.nil?
        acc = p
        next
      end
      acc = yield(acc, p)
    end
    acc
  end
end

def multiply_else(arr)
  result = arr.my_inject do |memo, curr|
    memo * curr
  end
  result
end
