#!/home/manezeu/.rbenv/shims/ruby

# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Style/For, Metrics/BlockNesting, Layout/LineLength, Style/ConditionalAssignment, Metrics/ModuleLength, Metrics/AbcSize, Metrics/MethodLength
module Enumerable
  def my_each
    return to_enum unless block_given?

    caller = self
    if caller.class == Array || caller.class == Range
      for item in caller
        yield(item)
      end
    elsif caller.class == Hash
      for item in caller.keys
        yield(item, caller[item])
      end
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    caller = self
    if caller.class == Array
      for index in (0...caller.length)
        yield(caller[index], index)
      end
    elsif caller.class == Hash
      for index in caller.keys
        yield(caller[index], index)
      end
    end
  end

  def my_select
    return to_enum unless block_given?

    caller = self
    if caller.class == Array || caller.class == Range
      arr = []
      caller.my_each { |item| arr.push(item) if yield(item) }
      arr
    elsif caller.class == Hash
      hash = {}
      caller.my_each { |key, value| hash[key] = value if yield(key, value) }
      hash
    end
  end

  def my_all?(param = nil)
    result = true
    caller = self
    if caller.class == Array || caller.class == Range
      if !param.nil?
        param.class == Regexp ? caller.my_each { |item| result = false unless param.match?(item) } : caller.my_each { |item| result = false unless item.class <= param }
      else
        block_given? ? caller.my_each { |item| result = false unless yield(item) } : caller.my_each { |item| result = false if !item || item.nil? }
      end
    elsif caller.class == Hash
      if !param.nil?
        param.class == Regexp ? caller.my_each { |_key, value| result = false unless my_pattern.match?(value) } : caller.my_each { |_key, value| result = false unless value.class <= param }
      else
        block_given? ? caller.my_each { |_key, value| result = false unless yield(key, value) } : caller.my_each { |_key, value| result = false if !value || value.nil? }
      end
    end
    result
  end

  def my_any?(param = nil)
    result = false
    caller = self
    if caller.class == Array || caller.class == Range
      if !param.nil?
        param.class == Regexp ? caller.my_each { |item| result = true if param.match?(item) } : caller.my_each { |item| result = true if item.class <= param }
      else
        block_given? ? caller.my_each { |item| result = true if yield(item) } : caller.my_each { |item| result = true if item && !item.nil? }
      end
    elsif caller.class == Hash
      if !param.nil?
        param.class == Regexp ? caller.my_each { |_key, value| result = true if my_pattern.match?(value) } : caller.my_each { |_key, value| result = true if value.class <= param }
      else
        block_given? ? caller.my_each { |_key, value| result = true if yield(key, value) } : caller.my_each { |_key, value| result = true if value && !value.nil? }
      end
    end
    result
  end

  def my_none?(param = nil)
    result = nil
    caller = self
    if caller.class == Array || caller.class == Range
      block_given? ? result = !caller.my_any? { |item| yield(item) } : result = !caller.my_any?(param)
    elsif caller.class == Hash
      block_given? ? result = !caller.my_any? { |key, value| yield(key, value) } : result = !caller.my_any?(param)
    end
    result
  end

  def my_count(param = nil)
    result = 0
    caller = self
    if caller.class == Array || caller.class == Range
      if !param.nil?
        caller.my_each { |item| result += 1 if item == param }
      else
        block_given? ? caller.my_each { |item| result += 1 if yield(item) } : caller.my_each { |_item| result += 1 }
      end
    elsif caller.class == Hash
      if !param.nil?
        caller.my_each { |_key, value| result += 1 if value == param }
      else
        block_given? ? caller.my_each { |_key, value| result += 1 if yield(key, value) } : caller.my_each { |_key, _value| result += 1 }
      end
    end
    result
  end

  def my_map(my_proc = nil)
    return to_enum unless block_given? || my_proc

    caller = self
    result = nil
    if caller.class == Array || caller.class == Range
      result = []
      my_proc ? caller.my_each { |item| result.push(my_proc.call(item)) } : caller.my_each { |item| result.push(yield(item)) }
    elsif caller.class == Hash
      result = {}
      my_proc ? caller.my_each { |key, value| result[key] = my_proc.call(value) } : caller.my_each { |key, value| result[key] = yield(key, value) }
    end
    result
  end

  def my_inject(*param)
    size = param.length
    return to_enum if !block_given? && size.zero?

    caller = self
    memo = nil
    if caller.class == Array || caller.class == Range
      case size
      when 0
        caller.class == Range ? memo = caller.first : memo = caller[0]
        my_arr = caller.to_a
        my_arr.shift
        my_arr.my_each { |item| memo = yield(memo, item) }
      when 1
        if block_given?
          memo = param[0]
          caller.my_each { |item| memo = yield(memo, item) }
        else
          method = param[0]
          caller.class == Range ? memo = caller.first : memo = caller[0]
          my_arr = caller.to_a
          my_arr.shift
          my_arr.my_each { |item| memo = memo.send(method, item) }
        end
      when 2
        method = param[1]
        memo = param[0]
        caller.my_each { |item| memo = memo.send(method, item) }
      end
    elsif caller.class == Hash
      my_hash = caller
      case size
      when 0
        memo = caller.first
        my_hash.shift
        my_hash.my_each { |_key, value| memo = yield(memo, value) }
      when 1
        if block_given?
          memo = param[0]
          caller.my_each { |_key, value| memo = yield(memo, value) }
        else
          method = param[0]
          memo = caller.first
          my_hash.shift
          my_hash.my_each { |_key, value| memo = memo.send(method, value) }
        end
      when 2
        method = param[1]
        memo = param[0]
        caller.my_each { |_key, value| memo = memo.send(method, value) }
      end
    end
    memo
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Style/For, Metrics/BlockNesting, Layout/LineLength, Style/ConditionalAssignment, Metrics/ModuleLength, Metrics/AbcSize, Metrics/MethodLength
