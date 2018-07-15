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

  def self.friend
    events = client.parse_events_from(body)
    events.each { |event|
      case event
        # LINEお友達追された場合
      when Line::Bot::Event::Follow
        # 登録したユーザーのidをユーザーテーブルに格納
        line_id = event['source']['userId']
        SunUser.create(line_id: line_id)
        # LINEお友達解除された場合
      when Line::Bot::Event::Unfollow
        # お友達解除したユーザーのデータをユーザーテーブルから削除
        line_id = event['source']['userId']
        SunUser.find_by(line_id: line_id).destroy
      end
    }
    head :ok
  end

  def client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET_SUN"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN_SUN"]
    }
  end
end
