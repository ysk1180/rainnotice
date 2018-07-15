class SunglassesController < ApplicationController
  require 'line/bot'
  require 'sunglasses_controller.rb'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def callback
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    Sunglasses.friend
  end
end
