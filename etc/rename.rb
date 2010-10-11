#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'right_aws'
require 'pp'

aws_auth = YAML.load_file("#{ENV["HOME"]}/.s3conf/s3config.yml")

config = YAML.load_file("config.yml")

access_key = aws_auth["aws_access_key_id"]
secret_key = aws_auth["aws_secret_access_key"]


f = File.open("findAll.json")
json = f.readlines.join

obj = JSON.parse(json)
json = nil
rows = obj['rows']
obj = nil


s3 = RightAws::S3.new(access_key, secret_key)
bucket = s3.bucket config["to_be_indexed_bucket"]
#keys = bucket.keys

#for key in keys
#  puts key
#end


for row in rows
  id = row["id"]
  file =  row["value"]["file"]
  next unless file.downcase =~ /\.mp3$/
  key = RightAws::S3::Key.create(bucket, file)
  puts "exists? #{key.exists?}"
  unless key.exists?
    STDERR.puts "DOES NOT EXIST: #{key}.mp3"
    next
  end
  
  puts "new name: #{id}.mp3 old name: #{key}"
  key.rename("#{id}.mp3")
  puts "renamed key exists? #{key.exists?}"
  
  #exit if true
end