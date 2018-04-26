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
  
  def self.parse_period(period)
    year = period.to_s[0, 4].to_i
    month = period.to_s[4, 2].to_i
    Date.new(year, month, 1)
  end
end
