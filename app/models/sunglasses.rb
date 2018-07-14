class Sunglasses
  require 'line/bot'
  def self.sunglasses_main
    weather = Weather.weather
    puts weather
  end
  def client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET_SUN"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN_SUN"]
    }
  end
end
