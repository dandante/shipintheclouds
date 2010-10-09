class MainController < ApplicationController
  
  require 'lib/signurl.rb'
  include SignUrl
  
  def get_url
    logger.info "song = #{params[:song]}"
    song = params[:song]
    url = get_signed_url(song.gsub(" ", "%20"))
    render :text => url
  end
  
  
  def test
    render :text => MUSIC_BUCKET
  end
  
  def foo
    logger.info "fooooo"
    render :text => "bar"
  end
end
