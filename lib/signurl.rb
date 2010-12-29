module SignUrl
  
  require 'rubygems'
  require 'right_aws'
  require 'fileutils'
  
  require "#{RAILS_ROOT}/lib/S3.rb"
  include S3
  
  @@digest1 = OpenSSL::Digest::Digest.new("sha1")
  @@digest256 = OpenSSL::Digest::Digest.new("sha256") rescue nil


  def sign_request_v2(aws_secret_access_key, service_hash, http_verb, host, uri)
    RightAws::AwsUtils.fix_service_params(service_hash, '2')
    # select a signing method (make an old openssl working with sha1)
    # make 'HmacSHA256' to be a default one
    service_hash['SignatureMethod'] = 'HmacSHA256' unless ['HmacSHA256', 'HmacSHA1'].include?(service_hash['SignatureMethod'])
    service_hash['SignatureMethod'] = 'HmacSHA1'   unless @@digest256
    # select a digest
    digest = (service_hash['SignatureMethod'] == 'HmacSHA256' ? @@digest256 : @@digest1)
    # form string to sign
    canonical_string = service_hash.keys.sort.map do |key|
      "#{RightAws::AwsUtils.amz_escape(key)}=#{RightAws::AwsUtils.amz_escape(service_hash[key])}"
    end.join('&')


    string_to_sign = "#{http_verb.to_s.upcase}\n\n\n#{service_hash["Expires"]}\n/#{MUSIC_BUCKET}#{uri}"

    logger.info  "string_to_sign:"
    logger.info string_to_sign

    hex_ary = [] 
    string_to_sign.each_char do |ch|
      hexnum = ch.unpack('H*')[0]
      hex_ary.push(hexnum)
    end

    logger.info "RHINO_HOME = #{RHINO_HOME}"
    logger.info "hex_ary = \n#{hex_ary.join " "}"

    pwd = FileUtils.pwd
    
    if JAVA_HOME == ""
      java_bin = ""
    else
      java_bin = "#{JAVA_HOME}/bin/"
    end
    
    
    if `hostname`.chomp =~ /fhcrc/
      filename = "#{ENV['HOME']}/.s3conf/s3config.yml.dandante"
    else
      filename = "#{ENV['HOME']}/.s3conf/s3config.yml"
    end
    
    
    signature = `cd #{RHINO_HOME} && #{java_bin}java -jar -jar js-14.jar #{RAILS_ROOT}/etc/getsignature.js #{filename} "#{hex_ary.join(" ")}"`.chomp
    logger.info "got signature from rhino: #{signature}"

    "#{canonical_string}&Signature=#{signature}"
  end

  
  
  
  
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
    
    #logger.info "secret key = #{secret_key}"


    now = Time.now.to_i

    hour = (60 * 60)

    expires = now + (48 * hour)

    host = "#{MUSIC_BUCKET}.s3.amazonaws.com"
    uri = "/#{song}" 

    #cs = S3.canonical_string("GET", "music19671025", "6b05aed0-b082-012d-db52-549a200f1604.mp3", {}, {}, 1293754016)
    canonical_string = S3.canonical_string("GET", MUSIC_BUCKET, song, {}, {}, expires)
    signature = S3.encode(secret_key, canonical_string, true) 
    
    #https://music19671025.s3.amazonaws.com/6b05aed0-b082-012d-db52-549a200f1604.mp3?Expires=1293754016&SignatureMethod=HmacSHA256&SignatureVersion=2&Signature=M47BmCTkaJnHyjy4xxGLe5FEvRM%3D&AWSAccessKeyId=0326Q1B6BA9DDXD1PQR2
    url = "https://#{host}#{uri}?Expires=#{expires}&SignatureMethod=HmacSHA256&SignatureVersion=2&Signature=#{signature}&AWSAccessKeyId=#{access_key}"
    

    #service_hash = {"Expires" => expires}
    #signature = sign_request_v2(secret_key, service_hash, "GET", host, uri)


    #result = "https://#{host}#{uri}?AWSAccessKeyId=#{access_key}&#{signature}"
    #result
  end
end