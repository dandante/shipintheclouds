class MainController < ApplicationController
  
  if RAILS_ENV == "production"
    before_filter :authenticate,:only => [:main]
  end
  
  
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
  
  def redir
    redirect_to "https://s3.amazonaws.com/music19671025/0001ee40-b081-012d-db52-549a200f1604.mp3?AWSAccessKeyId=AKIAJBHAI75QI6ANOM4Q&Expires=1286747750&Signature=y5ivqh0BE2%2BVMyvoCM%2BsmTTzArg%3D&x-amz-security-token=%7BUserToken%7DAAAHVXNlclRrbusKz1jOQXB3kUYOz7xxSCgEsSZObnXWbQ3xGfcDdHfH1CV6yCAMP3hS/LUFazcvgeot9VEuV61DpJBy7eP7rGnRDYvDF9YB3rv8R0C2JL9blzaqYI7bgEW6C470HJ8VEIz19zMLGlHq/MRpmMZLGCQTabI7D56J5YudajkpSu/bYb%2B9pE3ZqU5HiUXEac9dxZ6UHxNOff8nBrH3z3/HHrxp%2B%2BDbjcHQ%2B%2BUDVvCNrTfVFm8yRcdQHzmwzcP88DY74X6ae6aCN6iBCD7zlvWd0fTfzb3/kHquAF3YU8m0SGcCHOGGBi8lhkCqcarWhPgi9Gj7%2By62G6Vh2B1%2BfMw38jk%3D"
  end
  
private
  
  def authenticate
    authenticate_or_request_with_http_basic do |id, password| 
              id == SHIPINTHECLOUDS_LOGIN && password == SHIPINTHECLOUDS_PASSWORD
    end
  end
  
end
