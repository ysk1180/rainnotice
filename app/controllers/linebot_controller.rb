class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'
  require 'open-uri'
  require 'kconv'
  require 'rexml/document'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    # 仮でここに記載
    url  = "http://www.drk7.jp/weather/xml/13.xml"
    xml  = open( url ).read.toutf8
    doc = REXML::Document.new(xml)
    xpath = 'weatherforecast/pref/area[4]/info'
    weather = doc.elements[xpath + '/weather'].text
    per06to12 = doc.elements[xpath + '/rainfallchance/period[2]l'].text
    per12to18 = doc.elements[xpath + '/rainfallchance/period[3]l'].text
    per18to24 = doc.elements[xpath + '/rainfallchance/period[4]l'].text
    MIN_PER = 30
    if per06to12.to_i >= MIN_PER || per12to18.to_i >= MIN_PER || per18to24.to_i >= MIN_PER
      push = "今日は傘を持っていってね！#{weather}だよ"
    end

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: push
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    }

    head :ok
  end
end
