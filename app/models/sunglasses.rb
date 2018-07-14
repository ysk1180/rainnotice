class Sunglasses
  require 'line/bot'
  def self.sunglasses_main
    # 本日が休日（土日・祝日）に当たるかの取得
    holiday_or_not = Holiday.holiday(Date.today)
    puts holiday_or_not
    # 本日の天気の取得
    weather = Weather.weather
  end
  def client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET_SUN"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN_SUN"]
    }
  end
end
