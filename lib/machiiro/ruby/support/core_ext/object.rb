TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE', 'on', 'ON'].to_set

class Object
  def is_array?
    is_a?(Array)
  end

  def to_b
    TRUE_VALUES.include?(self)
  end

  def to_sym
    nil? ? nil : to_s.to_sym
  end

  def load_once(name)
    value = instance_variable_get(name)
    if value.nil?
      value = yield
      instance_variable_set(name, value)
    end
    value
  end
end
