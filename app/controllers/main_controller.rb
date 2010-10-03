class MainController < ApplicationController
  
  require 'lib/signurl.rb'
  include SignUrl
  
  def get_url
    song = params[:song]
    url = get_signed_url(song.gsub(" ", "+"))
    render :text => url
  end
  
end
