#!/usr/bin/env ruby

require 'rubygems'
require 'mp3info'
require './couch.rb'
require 'UUID'
require 'json'
require 'pp'
$KCODE = 'u'
require 'jcode'
require 'unicode'

include Couch

unless ARGV.size == 1
  puts "supply a directory to index"
  exit
end

@uuid_generator = UUID.new
$KCODE = 'UTF-8'

def as_json(mp3, file)
  hsh = {}
  hsh["file"] = file
  hsh["length"] = mp3.length
  mp3.tag.each_pair do |k,v|
    v = Unicode::compose v if v.is_a? String
    hsh[k] = v
  end
  #hsh.delete("comments")
  #hsh.delete("title")
  return JSON.pretty_generate(hsh)
end

dir = ARGV.first.gsub(/\/$/, "")
server = Couch::Server.new("localhost", "5984")

i = 0

#words = Hash.new { |h, k| h[k] = 0 }
Dir.glob("#{dir}/**/*.mp3") do |f|
  i += 1
  exit if i == 50
  rel_path = f.gsub(/^#{dir}\//, "")
  puts "file = #{rel_path}"
  mp3info = nil
  begin
    mp3info = Mp3Info.new(f)
  rescue Exception => ex
    puts "ERROR: this is probably not an mp3 file"
    next
  end
  #pp mp3info
  json = as_json(mp3info, rel_path)
  puts json
  id = @uuid_generator.generate
  server.put("/toy/#{id}", json)
end
