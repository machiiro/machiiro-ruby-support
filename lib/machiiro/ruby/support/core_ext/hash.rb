class Hash
  def as_time(name, format)
    return nil if self[name].nil?

    begin
      return Time.strptime(self[name], format)
    rescue ArgumentError
      return nil
    end
  end

  def sort_key
    Hash[sort]
  end

  def extract(*names)
    result = {}
    names.each do |name|
      result[name] = self[name.to_sym] unless self[name.to_sym].nil?
    end
    result
  end

  def trim
    keys.each_with_object({}) do |k, h|
      v = self[k]

      h[k] = if v.is_a?(String)
               v.strip
             elsif v.is_a?(Hash)
               v.trim
             else
               v
             end
    end
  end

  def delete_keys(*keys)
    keys.each { |k| delete(k) }
  end

  def delete_recursive(name)
    keys.each do |key|
      delete(key) if key.to_s.include?(name.to_s)

      self[key].delete_recursive(name) if self[key].is_a?(Hash)
    end
  end
end
