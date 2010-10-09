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


    string_to_sign = "#{http_verb.to_s.upcase}\n\n\n#{service_hash["Expires"]}\n/#{MUSIC_BUCKET}#{uri}"


    hex_ary = [] 
    string_to_sign.each_char do |ch|
      hexnum = ch.unpack('H*')[0]
      hex_ary.push(hexnum)
    end


    pwd = FileUtils.pwd
    signature = `cd #{RHINO_HOME} && java -jar -jar js-14.jar #{RAILS_ROOT}/etc/getsignature.js "#{hex_ary.join(" ")}"`.chomp
    logger.info "got signature from rhino: #{signature}"

    "#{canonical_string}&Signature=#{signature}"
  end

  
  
  
  
  def get_signed_url(song)
    logger.info "in get_signed_url"
    aws_auth = YAML.load_file("#{ENV["HOME"]}/.s3conf/s3config.yml")

    secret_key = aws_auth["aws_secret_access_key"]
    access_key = aws_auth["aws_access_key_id"]


    now = Time.now.to_i

    hour = (60 * 60)

    expires = now + (48 * hour)

    host = "#{MUSIC_BUCKET}.s3.amazonaws.com"
    uri = "/#{song}" 

    service_hash = {"Expires" => expires}
    signature = sign_request_v2(secret_key, service_hash, "GET", host, uri)


    result = "https://#{host}#{uri}?AWSAccessKeyId=#{access_key}&#{signature}"
    result
  end
end