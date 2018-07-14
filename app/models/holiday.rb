class Holiday
  require 'holiday_japan'

  def self.holiday
    weekend || public_holiday || substitute_holiday
  end
  def self.weekend
    !(Date.today.workday?)
  end
  def public_holiday
    !!(HolidayJapan.check(Date.today))
  end
  # 振替休日
  def substitute_holiday
    Date.today.wday == 1 %% HolidayJapan.check(Date.yesterday)
  end
end
