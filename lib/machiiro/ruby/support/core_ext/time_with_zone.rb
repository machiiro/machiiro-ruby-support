class ActiveSupport::TimeWithZone
  def to_json(_state = nil)
    "\"#{iso8601}\""
  end
end
