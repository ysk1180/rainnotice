class SunglassesController < ApplicationController

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def callback
    Sunglasses.friend
  end
end
