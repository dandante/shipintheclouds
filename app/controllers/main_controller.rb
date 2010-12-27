class MainController < ApplicationController
  require 'pp'
  
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
  
  def search
    # sord = ASC|DESC
    # rows = 10
    # sidx = (column to sort by)
    # page = 1
    # searchcol = any | title | album |artist (any also includes file)
    # _search = a query(?)
    
    sord = (params.has_key?(:sord)) ? params[:sord] : "asc"
    rows = (params.has_key?(:rows)) ? params[:rows] : 20
    sidx = (params.has_key?(:sidx)) ? params[:sidx] : "title_c"
    page = (params.has_key?(:page)) ? params[:page].to_i() - 1 : 0
    searchcol = params[:searchcol]
    query = "%#{params[:query]}%"
    
    sql = <<"EOF"
    
		
    select title, artist, album, file, length, id, uuid
    from songs
    where 
      (hidden = 0 or hidden is null)
    and
      WHERECLAUSES
    
    order by ? ASCDESC
    limit ? offset ?
EOF
    if (sord.downcase == "asc" or sord.downcase == "desc") 
      sql.gsub! "ASCDESC", sord
    end

    if searchcol == "any"
      whereclauses = "(title like ? or album like ? or album like ? or file like ?)"
    else
      whereclauses = "(#{searchcol} like ?  )"
    end
    
    sql.gsub! "WHERECLAUSES", whereclauses
    
    if searchcol === "any"
      results = Song.find_by_sql [sql, query, query, query, query, sidx, rows, page]
    else
      results = Song.find_by_sql [sql, query, sidx, rows, page]
    end
    
    uber = {}
    uber['rows'] = results
    uber['page'] = "1"#page.to_s
    uber['totalpages'] = "50"
    uber['totalrecords'] = "500"
    render :text => uber.to_json
    
  end
  
  def post_data
    if params[:oper] == "del"
      Song.find(params[:id]).destroy
    else
      user_params = { :pseudo => params[:pseudo], :firstname => params[:firstname], :lastname => params[:lastname], 
                      :email => params[:email], :role => params[:role] }
      if params[:id] == "_empty"
        Song.create(user_params)
      else
        Song.find(params[:id]).update_attributes(user_params)
      end
    end
    render :nothing => true
  end

  def blah
    users = Song.find(:all, :limit => 24) do
      if params[:_search] == "true"
        title_c    =~ "%#{params[:title_c]}%" if params[:title_c].present?
        artist_c =~ "%#{params[:artist_c]}%" if params[:artist_c].present?
        album_c  =~ "%#{params[:album_c]}%" if params[:album_c].present?                
        file_c     =~ "%#{params[:file_c]}%" if params[:file_c].present?
      end
      paginate :page => params[:page], :per_page => params[:rows]      
      order_by "#{params[:sidx]} #{params[:sord]}"
    end

    respond_to do |format|
      format.html
      format.json { render :json => users.to_jqgrid_json([:id,:title_c,:artist_c,:album_c,:uuid,:file_c], 
                                                         params[:page], params[:rows], users.total_entries) }
    end
  end
  
  def test
    render :text => MUSIC_BUCKET
  end
  
  def foo
    logger.info "fooooo"
    render :text => "bar"
  end
  
  
  def gridtest
    puts "params:"
    pp params
    #send_file "#{RAILS_ROOT}/public/dummydata.json"
    render :file => "#{RAILS_ROOT}/public/dummydata.json"
  end
  
  def default_query
    
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
