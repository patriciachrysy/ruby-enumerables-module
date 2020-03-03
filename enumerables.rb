#!/home/manezeu/.rbenv/shims/ruby

# rubocop:disable Style/CaseEquality
module Enumerable
  def my_each
      return to_enum unless block_given?
      if self.class == Array || self.class == Range
        for item in self
            yield(item)
        end
      elsif self.class == Hash
        for item in self.keys
            yield(item, self[item])
        end
      end
      self
  end

  def my_each_with_index
      return to_enum unless block_given?
      if self.class == Array
        for index in (0...self.length)
            yield(self[index], index)
        end
      elsif self.class == Hash
        for item in self.keys
            yield(self[index], index)
        end
      end
      self
  end

  def my_select
    return to_enum unless block_given?
    if self.class == Array || self.class == Range
      arr = Array.new
      self.my_each{|item| arr.push(item) if yield(item) }
      return arr
    elsif self.class == Hash
      hash = Hash.new
      self.my_each{|key, value| hash[key]=value if yield(key, value) }
      return hash
    end
    self
  end

  def my_all?(param = nil)
    result = true
    if self.class == Array || self.class == Range
      if param!=nil
          param.class==Regexp ? self.my_each{|item| result=false unless param.match?(item)} : self.my_each{|item| result=false unless item.class<=param}
      else
          block_given? ? self.my_each{|item| result=false unless yield(item) } : self.my_each{|item| result=false if item==false || item==nil }
      end
    elsif self.class == Hash
      if param!=nil
          param.class==Regexp ? self.my_each{|key, value| result=false unless my_pattern.match?(value)} : self.my_each{|key, value| result=false unless value.class<=param}
      else
          block_given? ? self.my_each{|key, value| result=false unless yield(key, value) } : self.my_each{|key, value| result=false if value==false || value==nil }
      end
    end
    result
  end

  def my_any?(param = nil)
    result = false
    if self.class == Array || self.class == Range
      if(param!=nil)
        param.class==Regexp ? self.my_each{|item| result=true if param.match?(item)} : self.my_each{|item| result=true if item.class<=param}
      else
        block_given? ? self.my_each{|item| result=true if yield(item) } : self.my_each{|item| result=true if item!=false && item!=nil }
      end
    elsif self.class == Hash
      if(param!=nil)
        param.class==Regexp ? self.my_each{|key, value| result=true if my_pattern.match?(value)} : self.my_each{|key, value| result=true if value.class<=param}
      else
        block_given? ? self.my_each{|key, value| result=true if yield(key, value) } : self.my_each{|key, value| result=true if value!=false && value!=nil }
      end
    end
    result
  end

  def my_none?(param = nil)
    result = nil
    if self.class == Array || self.class == Range
      block_given? ? result=!self.my_any?{|item| yield(item)} : result=!self.my_any?(param)
    elsif self.class == Hash
      block_given? ? result=!self.my_any?{|key, value| yield(key, value)} : result=!self.my_any?(param)
    end
    result
  end

  def my_count(param = nil)
    result = 0
    if self.class == Array || self.class == Range
      if param!=nil
        self.my_each{|item| result+=1 if item==param}
      else
        block_given? ? self.my_each{|item| result+=1 if yield(item)} : self.my_each{|item| result+=1}
      end
    elsif self.class == Hash
      if param!=nil
        self.my_each{|key, value| result+=1 if value==param}
      else
        block_given? ? self.my_each{|key, value| result+=1 if yield(key, value)} : self.my_each{|key, value| result+=1}
      end
    end
    result
  end

  def my_map(my_proc = nil)
    return to_enum unless block_given? || my_proc
    result = self
    if self.class == Array || self.class == Range
      result = Array.new
      my_proc ? self.my_each{|item| result.push(my_proc.call(item))} : self.my_each{|item| result.push(yield(item))}
    elsif self.class == Hash
      result = Hash.new
      my_proc ? self.my_each{|key, value| result[key]=my_proc.call(value)} : self.my_each{|key, value| result[key]=yield(key, value)}
    end
    result
  end

  def my_inject(*param)
    size = param.length
    return to_enum if !block_given? && size==0
    if self.class == Array || self.class == Range
      case size
      when 0
        self.class==Range ? memo=self.first : memo = self[0]
        my_arr = self.to_a
        my_arr.shift
        my_arr.my_each{|item| memo=yield(memo, item)}
        return memo
      when 1
        if block_given?
          memo = param[0]
          self.my_each{|item| memo=yield(memo, item)}
          return memo
        else
          method = param[0]
          self.class==Range ? memo=self.first : memo = self[0]
          my_arr = self.to_a
          my_arr.shift
          my_arr.my_each{|item| memo = memo.send(method, item) }
          return memo
        end
      when 2
        method = param[1]
        memo = param[0]
        self.my_each{|item| memo = memo.send(method, item) }
        return memo
      end
    elsif self.class == Hash
      my_hash = self
      case size
      when 0
        memo=self.first
        my_hash.shift
        my_hash.my_each{|key, value| memo=yield(memo, value)}
        return memo
      when 1
        if block_given?
          memo = param[0]
          self.my_each{|key, value| memo=yield(memo, value)}
          return memo
        else
          method = param[0]
          memo=self.first
          my_hash.shift
          my_hash.my_each{|key, value| memo = memo.send(method, value) }
          return memo
        end
      when 2
        method = param[1]
        memo = param[0]
        self.my_each{|key, value| memo = memo.send(method, value) }
        return memo
      end
    end
  end
end

def multiply_els(arr)
 arr.my_inject(:*)
end
# rubocop:enable Style/CaseEquality
