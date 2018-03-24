module JSON
  def self.parse_safe(json_str)
    JSON.parse(json_str)
  rescue JSON::ParserError
    nil
  end

  def self.parse_symbol(json_str)
    return nil if json_str.nil?
    JSON.parse(json_str, symbolize_names: true)
  end

  def self.parse_symbol_safe(json_str)
    JSON.parse_symbol(json_str)
  rescue JSON::ParserError
    nil
  end
end
