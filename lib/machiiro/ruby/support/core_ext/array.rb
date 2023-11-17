class Array
  def to_h_key(key)
    each_with_object({}) do |e, hash|
      if e.is_a?(Hash)
        hash[e[key.to_sym]] = e
      else
        hash[e.send(key.to_sym)] = e
      end
    end
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
