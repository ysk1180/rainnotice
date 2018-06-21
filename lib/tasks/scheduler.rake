desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  require 'line/bot'  # gem 'line-bot-api'
  require 'open-uri'
  require 'kconv'
  require 'rexml/document'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }

  url  = "http://www.drk7.jp/weather/xml/13.xml"
  xml  = open( url ).read.toutf8
  doc = REXML::Document.new(xml)
  xpath = 'weatherforecast/pref/area[4]/info'
  weather = doc.elements[xpath + '/weather'].text
  per06to12 = doc.elements[xpath + '/rainfallchance/period[2]l'].text
  per12to18 = doc.elements[xpath + '/rainfallchance/period[3]l'].text
  per18to24 = doc.elements[xpath + '/rainfallchance/period[4]l'].text
  min_per = 20
  if per06to12.to_i >= min_per || per12to18.to_i >= min_per || per18to24.to_i >= min_per
    push = "今日は傘を持っていってね！#{weather}だよ"
  else
    push = "テスト用"
  end

  user_ids = "U96a2790cfba425cb1e422d6f00c3a877"

  message = {
    type: 'text',
    text: push
  }
  response = client.multicast(user_ids, message)
    }

    head :ok
end
