module SignUrl
  
  
  require "#{RAILS_ROOT}/lib/S3.rb"
  include S3
  
  
  def get_signed_url(song)
    logger.info "in get_signed_url"
    
    if `hostname`.chomp =~ /fhcrc/
      filename = "s3config.yml.dandante"
    else
      filename = "s3config.yml"
    end
    
    aws_auth = YAML.load_file("#{ENV["HOME"]}/.s3conf/#{filename}")

    secret_key = aws_auth["aws_secret_access_key"]
    access_key = aws_auth["aws_access_key_id"]
    
    now = Time.now.to_i

    hour = (60 * 60)

    expires = now + (48 * hour)

    host = "#{MUSIC_BUCKET}.s3.amazonaws.com"
    uri = "/#{song}" 

    canonical_string = S3.canonical_string("GET", MUSIC_BUCKET, song, {}, {}, expires)
    signature = S3.encode(secret_key, canonical_string, true) 
    
    url = "https://#{host}#{uri}?Expires=#{expires}&SignatureMethod=HmacSHA256&SignatureVersion=2&Signature=#{signature}&AWSAccessKeyId=#{access_key}"
  end
end