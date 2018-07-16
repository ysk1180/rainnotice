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
        client ||= Line::Bot::Client.new { |config|
          config.channel_secret = ENV["LINE_CHANNEL_SECRET_SUN"]
          config.channel_token = ENV["LINE_CHANNEL_TOKEN_SUN"]
        }
        # メッセージの発信先idを配列で渡す必要があるため、userテーブルよりpluck関数を使ってidを配列で取得
        user_ids = SunUser.all.pluck(:line_id)
        message = {
          type: 'text',
          text: word
        }
        response = client.multicast(user_ids, message)
        "OK"
      end
    end
  end
end
