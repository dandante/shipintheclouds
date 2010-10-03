#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'pp'

unless ARGV.size == 1
  puts "supply a database name"
  exit
end

database = ARGV.first

hsh = {}

hsh["id"] = "_design/example"
views = {}

f = File.open("map.js")

key = nil

while (line = f.gets)
  if line =~ /^\/\/map:/
    key = line.chomp.split(":").last
    views[key] = {"map" => ""}
  end
  views[key]["map"] += line
end
#map = f.readlines.join

#views["foo"] = {"map" => map}

hsh["views"] = views



#puts JSON.pretty_generate(hsh)
#exit if true

results = `curl --silent http://localhost:5984/#{database}/_design/example/`
existing = JSON.parse(results)
#pp existing
rev = existing["_rev"]

results = `curl --silent -X DELETE http://localhost:5984/#{database}/_design/example?rev=#{rev}`
#puts results

tmp = File.open("tmp", "w")
tmp.puts JSON.pretty_generate(hsh)
tmp.close

results = `curl --silent -X PUT http://localhost:5984/#{database}/_design/example -d @tmp`
puts results

__END__

{
  "_id" : "_design/example",
  "views" : {
    "foo" : {
      "map" : "function(doc){ emit(doc._id, doc._rev)}"
    }
  }
}
