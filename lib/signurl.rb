module SignUrl
  
  require 'rubygems'
  require 'right_aws'
  require 'fileutils'

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


    # GET\n\n\n1286248115\n/music19671025/Away+Down+The+Road/01+Muskrat.mp3



    puts "canonical string:"
    puts canonical_string
    puts


    #string_to_sign = "#{http_verb.to_s.upcase}\n#{host.downcase}\n#{uri}\n#{canonical_string}"

    string_to_sign = "#{http_verb.to_s.upcase}\n\n\n#{service_hash["Expires"]}\n#{uri}"

    #js_sts = "GET\n\n\n1286248515\n/music19671025/Away+Down+The+Road/01+Muskrat.mp3"



    puts "string to sign:"
    puts string_to_sign
    #puts js_sts

    hex_ary = [] 
    string_to_sign.each_char do |ch|
      hexnum = ch.unpack('H*')[0]
      #puts "ch = #{ch} and hexnum = #{hexnum}" if hexnum.to_s == "34" or hexnum.to_s == "38"
      hex_ary.push(hexnum)
    end

    puts "hex string:"
    puts hex_ary.join " "

    pwd = FileUtils.pwd
    puts "BEFORE RHINO"
    signature = `cd #{RHINO_HOME} && java -jar -jar js-14.jar #{RAILS_ROOT}/etc/getsignature.js "#{hex_ary.join(" ")}"`.chomp
    puts "AFTER RHINO"
    puts "signature from rhino = #{signature}"

    puts

    # sign the string
    #signature      = RightAws::AwsUtils.amz_escape(Base64.encode64(OpenSSL::HMAC.digest(digest, aws_secret_access_key, string_to_sign)).strip)
    #"#{canonical_string}&Signature=#{signature}"
    #signature      = Base64.encode64(OpenSSL::HMAC.digest(digest, aws_secret_access_key, string_to_sign)).strip

    puts "signature:"
    puts signature
    puts

    "#{canonical_string}&Signature=#{signature}"
  end

  
  
  
  
  def get_signed_url(song)
    
    
    aws_auth = YAML.load_file("#{ENV["HOME"]}/.s3conf/s3config.yml")


    secret_key = aws_auth["aws_secret_access_key"]
    access_key = aws_auth["aws_access_key_id"]


    now = Time.now.to_i

    hour = (60 * 60)

    expires = now + (48 * hour)

    host = "s3.amazonaws.com"
    uri = "/music19671025/#{song}" # todo unhardcode bucket



    service_hash = {"Expires" => expires}
    #signature = RightAws::AwsUtils.sign_request_v2(secret_key, service_hash, "GET", host, uri)
    signature = sign_request_v2(secret_key, service_hash, "GET", host, uri)


    result = "https://#{host}#{uri}?AWSAccessKeyId=#{access_key}&#{signature}"
    #result = "https://#{host}#{uri}?#{signature}"

    puts result
    
    
    
    result
  end
end