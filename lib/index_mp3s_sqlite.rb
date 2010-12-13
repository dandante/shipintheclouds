#!/usr/bin/env ruby

require 'rubygems'
require 'UUID'
require 'json'
require 'pp'
$KCODE = 'u'
require 'jcode'
require 'unicode'


unless ARGV.size == 1
  puts "supply a file to index"
  exit
end

f = File.open(ARGV.first)
obj = JSON.parse(f.readlines.join)
f.close


fields = ["_id",
 "_rev",
 "album",
 "artist",
 "comments",
 "file",
 "genre",
 "genre_s",
 "length",
 "title",
 "tracknum",
 "year"]


allkeys = {}

id = 1

for row in obj["rows"]
  item = row["value"]
  s = "#{id}|"
  id += 1
  for field in fields
    if item.has_key? field
      s += "#{item[field].to_s.gsub(/\n/," ").gsub(/\r/, " ")}|"
    else
      s += "empty|"
    end
  end
  s.gsub!(/\|$/, "")
  puts s
end

