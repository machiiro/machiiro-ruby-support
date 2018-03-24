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
end
