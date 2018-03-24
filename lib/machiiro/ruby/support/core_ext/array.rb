class Array
  def to_h_key(key)
    map do |e|
      if e.is_a?(Hash)
        [e[key.to_sym], e]
      else
        [e.send(key.to_sym), e]
      end
    end.to_h
  end

  def to_h_array_key(key)
    result = {}
    each do |e|
      k = if e.is_a?(Hash)
            e[key.to_sym]
          else
            e.send(key.to_sym)
          end

      result[k] = [] unless result[k].present?
      result[k].push(e)
    end
    result
  end

  def include_array?(array)
    array.each do |e|
      return true if include?(e)
    end
    false
  end
end
