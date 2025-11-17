class Date
  def to_ymd
    strftime('%Y-%m-%d')
  end

  def to_ym_i
    strftime('%Y%m').to_i
  end

  def to_hm
    strftime('%H:%M')
  end

  def next_beginning_of_month(month)
    at_beginning_of_month + month.month
  end

  def next_end_of_month(month)
    (at_beginning_of_month + month.month).at_end_of_month
  end

  def self.parse_safe(value)
    Date.parse(value.to_s)
  rescue ArgumentError
    nil
  end

  def self.parse_period(period)
    year = period.to_s[0, 4].to_i
    month = period.to_s[4, 2].to_i
    Date.new(year, month, 1)
  end

  # Returns the date parsed from the target, otherwise returns the default value. Initially, the default value is nil.
  # @example
  #   Date.parse_period_safe('202511') # => Date.new(2025, 11, 1)
  #   Date.parse_period_safe(nil, Date.new(2025, 5, 1)) # => Date.new(2025, 5, 1)
  # @return [Date, nil]
  def self.parse_period_safe(period, default = nil)
    return default unless period_format? period
    parse_period period
  end

  # Returns the date parsed from the target, otherwise raises an error
  # @raise [ArgumentError] if the target is not a string with 6 digits
  # @return [Date]
  def self.parse_period!(period)
    raise ArgumentError, '"period" should can be a string with 6 digits' unless period_format? period
    parse_period period
  end

  def self.today_at_jst
    Time.now.to_jst.to_date
  end

  # Returns true if the target can be a number with 6 digits.
  # NOTE: This method does not check the format of the target.
  def self.period_format?(target)
    return false if target.nil?
    target.to_s.match?(/\A\d{6}\z/)
  end
end
