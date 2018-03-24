class Time
  def to_json(_state = nil)
    "\"#{iso8601}\""
  end

  def to_ms
    (to_f * 1000.0).to_i
  end

  def to_date
    Date.new(year, month, day)
  end

  def to_ymd
    strftime('%Y-%m-%d')
  end

  def to_ymdhm
    strftime('%Y-%m-%d %H:%M')
  end

  def to_ymdhms
    strftime('%Y-%m-%d %H:%M:%S')
  end

  def to_ym_i
    strftime('%Y%m').to_i
  end

  def to_ymd_i
    strftime('%Y%m%d').to_i
  end

  def to_hm
    strftime('%H:%M')
  end

  def at_beginning_time
    change_time(0, 0, 0)
  end

  def at_end_time
    change_time(23, 59, 59)
  end

  def change_time(hours, minutes = 0, seconds = 0)
    change(hour: hours, min: minutes, sec: seconds)
  end

  def next_end_of_month(month)
    (at_beginning_of_month + month.month).at_end_of_month
  end
end
