class Weather
  require 'open-uri'
  require 'kconv'
  require 'rexml/document'

  def self.weather
    url  = 'https://www.drk7.jp/weather/xml/13.xml'
    xml  = open(url).read.toutf8
    doc = REXML::Document.new(xml)
    doc.elements['weatherforecast/pref/area[4]/info/weather'].text
  end
end
