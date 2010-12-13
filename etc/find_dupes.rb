#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'pp'

f = File.open("findAll.json")
obj = JSON.parse(f.readlines.join)
rows = obj["rows"]
obj = nil

hsh = Hash.new()

for row in rows
  id = row["id"]
  value = row["value"]
  file = value["file"]
#  puts hsh[file].size
#  puts file
  hsh[file] = [] unless hsh.has_key? file
  hsh[file].push id
end

#pp hsh
hsh.each_pair do |k,v|
  puts v.size if v.size > 1
end
