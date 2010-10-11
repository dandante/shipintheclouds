#!/usr/bin/env ruby


require 'yaml'

require 'base64'
require 'openssl'
require 'digest/sha1'

aws_auth = YAML.load_file("#{ENV["HOME"]}/.s3conf/s3config.yml")

secret_key = aws_auth["aws_secret_access_key"]
access_key = aws_auth["aws_access_key_id"]

json_file = File.open("etc/upload_policy_doc.json")
json = json_file.readlines.join

policy = Base64.encode64(json).gsub("\n","")

puts "policy document:\n#{policy}\n\n"

signature = Base64.encode64(
    OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new('sha1'), 
        secret_key, policy)
    ).gsub("\n","")
    
puts "signature:\n#{signature}"