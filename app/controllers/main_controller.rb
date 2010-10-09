class MainController < ApplicationController
  
  require 'lib/signurl.rb'
  include SignUrl
  
  def get_url
    song = params[:song]
    url = get_signed_url(song.gsub(" ", "%20"))
    render :text => url
  end
  
  
  def test
    render :text => MUSIC_BUCKET
  end
end
