#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'pp'
require 'yaml'
$KCODE = 'u'
require 'unicode'


f = File.open(ARGV.first)
out = File.open("hash.yml", "w")

obj = JSON.parse(f.readlines.join)

h = {}

for row in obj["rows"]
  item = row["value"]
  s = item["file"]
  #puts s if s =~ /"/
  h[item["_id"]] = s
end

#puts JSON.pretty_generate(h)
#pp h
out.puts YAML::dump h