#!/home/manezeu/.rbenv/shims/ruby

# rubocop:disable Metrics/ModuleLength
module Enumerable
  def arr_range?(param)
    param.class == Array || param.class == Range
  end

  def hash?(param)
    param.class == Hash
  end

  def my_each
    return to_enum unless block_given?

    caller = self
    if arr_range?(caller)
      my_arr = caller.class == Range ? caller.to_a : caller
      my_arr.length.times { |item| yield(my_arr[item]) }
    elsif hash?(caller)
      keys_arr = caller.keys
      keys_arr.length.times { |key, _value| yield(keys_arr[key], caller[keys_arr[key]]) }
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    caller = self
    if arr_range?(caller)
      my_arr = caller.class == Range ? caller.to_a : caller
      my_arr.length.times { |index| yield(my_arr[index], index) }
    elsif hash?(caller)
      keys_arr = caller.keys
      keys_arr.length.times { |key, _value| yield(caller[keys_arr[key]], keys_arr[key]) }
    end
  end

  def my_select
    return to_enum unless block_given?

    caller = self
    if arr_range?(caller)
      arr = []
      caller.my_each { |item| arr.push(item) if yield(item) }
      arr
    elsif hash?(caller)
      hash = {}
      caller.my_each { |key, value| hash[key] = value if yield(key, value) }
      hash
    end
  end

  def with_param?(param, caller)
    res = true
    arr = [String, Integer, Float, FalseClass, TrueClass, Complex]
    if param.class == Regexp
      caller.my_each { |item| res = false unless param.match?(item) }
    elsif arr.include?(param.class)
      caller.my_each { |item| res = false unless item == param }
    else
      caller.my_each { |item| res = false unless item.class <= param }
    end
    res
  end

  def hash_with_param?(param, caller)
    res = true
    arr = [String, Integer, Float, FalseClass, TrueClass, Complex]
    if param.class == Regexp
      caller.my_each { |_key, value| res = false unless my_pattern.match?(value) }
    elsif arr.include?(param.class)
      caller.my_each { |_key, value| res = false unless value == param }
    else
      caller.my_each { |_key, value| res = false unless value.class <= param }
    end
    res
  end

  def with_block?(block, caller)
    res = true
    if block
      caller.my_each { |item| res = false unless yield(item) }
    else
      caller.my_each { |item| res = false if !item || item.nil? }
    end
    res
  end

  def hash_with_block?(block, caller)
    res = true
    if block
      caller.my_each { |_key, value| res = false unless yield(key, value) }
    else
      caller.my_each { |_key, value| res = false if !value || value.nil? }
    end
    res
  end

  def with_param_all?(block, param, caller)
    if !param.nil?
      with_param?(param, caller)
    else
      with_block?(block, caller) { |item| yield(item) }
    end
  end

  def hash_with_param_all?(block, param, caller)
    if !param.nil?
      hash_with_param?(param, caller)
    else
      hash_with_block?(block, caller) { |_key, value| yield(key, value) }
    end
  end

  def my_all?(param = nil)
    result = true
    caller = self
    if arr_range?(caller)
      result = with_param_all?(block_given?, param, caller) { |item| yield(item) }
    elsif hash?(caller)
      result = hash_with_param_all?(block_given?, param, caller) { |_key, value| yield(key, value) }
    end
    result
  end

  def with_param_any?(param, caller)
    res = false
    arr = [String, Integer, Float, FalseClass, TrueClass, Complex]
    if param.class == Regexp
      caller.my_each { |item| res = true if param.match?(item) }
    elsif arr.include?(param.class)
      caller.my_each { |item| res = true if item.== param }
    else
      caller.my_each { |item| res = true if item.class <= param }
    end
    res
  end

  def hash_with_param_any?(param, caller)
    res = false
    arr = [String, Integer, Float, FalseClass, TrueClass, Complex]
    if param.class == Regexp
      caller.my_each { |_key, value| res = true if my_pattern.match?(value) }
    elsif arr.include?(param.class)
      caller.my_each { |_key, value| res = true if value == param }
    else
      caller.my_each { |_key, value| res = true if value.class <= param }
    end
    res
  end

  def with_block_any?(block, caller)
    res = false
    if block
      caller.my_each { |item| res = true if yield(item) }
    else
      caller.my_each { |item| res = true if item && !item.nil? }
    end
    res
  end

  def hash_with_block_any?(block, caller)
    res = false
    if block
      caller.my_each { |_key, value| res = true if yield(key, value) }
    else
      caller.my_each { |_key, value| res = true if value && !value.nil? }
    end
    res
  end

  def get_param_any?(block, param, caller)
    if !param.nil?
      with_param_any?(param, caller)
    else
      with_block_any?(block, caller) { |item| yield(item) }
    end
  end

  def hash_get_param_any?(block, param, caller)
    if !param.nil?
      hash_with_param_any?(param, caller)
    else
      hash_with_block_any?(block, caller) { |_key, value| yield(key, value) }
    end
  end

  def my_any?(param = nil)
    result = false
    caller = self
    if arr_range?(caller)
      result = get_param_any?(block_given?, param, caller) { |item| yield(item) }
    elsif hash?(caller)
      result = hash_get_param_any?(block_given?, param, caller) { |_key, value| yield(key, value) }
    end
    result
  end

  def with_param_none?(block, param, caller)
    if block
      !caller.my_any? { |item| yield(item) }
    else
      !caller.my_any?(param)
    end
  end

  def hash_with_param_none?(block, param, caller)
    if block
      !caller.my_any? { |key, value| yield(key, value) }
    else
      !caller.my_any?(param)
    end
  end

  def my_none?(param = nil)
    result = nil
    caller = self
    if arr_range?(caller)
      result = with_param_none?(block_given?, param, caller) { |item| yield(item) }
    elsif hash?(caller)
      result = hash_with_param_none?(block_given?, param, caller) { |key, value| yield(key, value) }
    end
    result
  end

  def count_help(block, caller)
    res = 0
    if block
      caller.my_each { |item| res += 1 if yield(item) }
    else
      caller.my_each { |_item| res += 1 }
    end
    res
  end

  def hash_count_help(block, caller)
    res = 0
    if block
      caller.my_each { |key, value| res += 1 if yield(key, value) }
    else
      caller.my_each { |_key, _value| res += 1 }
    end
    res
  end

  def with_param_count(param, caller, block)
    res = 0
    if !param.nil?
      caller.my_each { |item| res += 1 if item == param }
    else
      res = count_help(block, caller) { |item| yield(item) }
    end
    res
  end

  def hash_with_param_count(param, caller, block)
    res = 0
    if !param.nil?
      caller.my_each { |_key, value| res += 1 if value == param }
    else
      res = hash_count_help(block, caller) { |key, value| yield(key, value) }
    end
    res
  end

  def my_count(param = nil)
    result = 0
    caller = self
    if arr_range?(caller)
      result = with_param_count(param, caller, block_given?) { |item| yield(item) }
    elsif hash?(caller)
      result = hash_with_param_count(param, caller, block_given?) { |key, value| yield(key, value) }
    end
    result
  end

  def with_proc_map(my_proc, caller)
    res = []
    if my_proc
      caller.my_each { |item| res.push(my_proc.call(item)) }
    else
      caller.my_each { |item| res.push(yield(item)) }
    end
    res
  end

  def hash_with_proc_map(my_proc, caller)
    res = {}
    if my_proc
      caller.my_each { |key, value| result[key] = my_proc.call(value) }
    else
      caller.my_each { |key, value| result[key] = yield(key, value) }
    end
    res
  end

  def my_map(my_proc = nil)
    return to_enum unless block_given? || my_proc

    caller = self
    result = nil
    if arr_range?(caller)
      result = with_proc_map(my_proc, caller) { |item| yield(item) }
    elsif hash?(caller)
      result = hash_with_proc_map(my_proc, caller) { |key, value| yield(key, value) }
    end
    result
  end

  def case_zero(caller)
    res = nil
    if arr_range?(caller)
      res = caller.class == Range ? caller.first : caller[0]
      my_arr = caller.to_a
      my_arr[1..-1].my_each { |item| res = yield(res, item) }
    elsif hash?(caller)
      res = caller.values.first
      caller.keys[1..-1].my_each { |value| res = yield(res, caller[value]) }
    end
    res
  end

  def case_one(method, caller)
    res = nil
    if arr_range?(caller)
      res = caller.class == Range ? caller.first : caller[0]
      my_arr = caller.to_a
      my_arr[1..-1].my_each { |item| res = res.send(method, item) }
    elsif hash?(caller)
      res = caller.values.first
      caller.keys[1..-1].my_each { |value| res = res.send(method, caller[value]) }
    end
    res
  end

  def case_one_spec(block, init, caller)
    res = nil
    if block
      res = init
      if arr_range?(caller)
        caller.my_each { |item| res = yield(res, item) }
      elsif hash?(caller)
        caller.my_each { |_key, value| res = yield(res, value) }
      end
    else
      method = init
      res = case_one(method, caller)
    end
    res
  end

  def case_two(init, method, caller)
    res = init
    if arr_range?(caller)
      caller.my_each { |item| res = res.send(method, item) }
    elsif hash?(caller)
      caller.my_each { |_key, value| res = res.send(method, value) }
    end
    res
  end

  def my_inject(*param)
    size = param.length
    return to_enum if !block_given? && size.zero?

    caller = self
    memo = nil
    case size
    when 0
      memo = case_zero(caller) { |init, item| yield(init, item) }
    when 1
      memo = case_one_spec(block_given?, param[0], caller) { |init, item| yield(init, item) }
    when 2
      method = param[1]
      init = param[0]
      memo = case_two(init, method, caller)
    end
    memo
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end
# rubocop:enable Metrics/ModuleLength
