class Sunglasses
  require 'line/bot'

  def self.sunglasses_main
    # 本日が休日（土日・祝日）に当たるかの取得
    holiday_or_not = Holiday.holiday(Time.zone.today)
    if holiday_or_not
      # 本日の天気の取得
      weather = Weather.weather
      if weather =~ /.*晴れ.*/
        word = Settings.word.warning
      end
    end
  end
end
