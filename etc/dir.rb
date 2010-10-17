#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'right_aws'
require 'pp'

aws_auth = YAML.load_file("#{ENV["HOME"]}/.s3conf/s3config.yml")

config = YAML.load_file("config/config.yml")

access_key = aws_auth["aws_access_key_id"]
secret_key = aws_auth["aws_secret_access_key"]




s3 = RightAws::S3.new(access_key, secret_key)
bucket = s3.bucket config["music_bucket"]
keys = bucket.keys

for key in keys
  puts key
end
