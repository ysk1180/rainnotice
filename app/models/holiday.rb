class Holiday
  require 'holiday_japan'

  def self.holiday(day)
    weekend(day) || public_holiday(day) || substitute_holiday(day)
  end

  def self.weekend(day)
    !day.workday?
  end

  def self.public_holiday(day)
    !!HolidayJapan.check(day)
  end

  # 振替休日
  def self.substitute_holiday(day)
    day.wday == 1 && !!HolidayJapan.check(day)
  end
end
