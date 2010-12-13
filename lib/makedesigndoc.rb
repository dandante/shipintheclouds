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

f = File.open("etc/map.js")

key = nil
functype = "map"

while (line = f.gets)
  if line =~ /^\/\/map:/
    key = line.chomp.split(":").last
    functype = "map"
    views[key] = {} unless views.has_key? key
    views[key][functype] = ""
    next
  elsif line =~ /^\/\/reduce:/
    key = line.chomp.split(":").last
    functype = "reduce"
    views[key] = {} unless views.has_key? key
    views[key][functype] = ""
    next
  end
  views[key][functype] += line
end
#map = f.readlines.join

#views["foo"] = {"map" => map}

hsh["views"] = views



#puts JSON.pretty_generate(hsh).gsub(/\\n/, "\n").gsub(/\\t/, "\t")
#exit if true

results = `curl --silent http://localhost:5984/#{database}/_design/example/`
existing = JSON.parse(results)
#pp existing
rev = existing["_rev"]

results = `curl --silent -X DELETE http://localhost:5984/#{database}/_design/example?rev=#{rev}`
#puts results

tmp = File.open("tmp.js", "w")
tmp.puts JSON.pretty_generate(hsh).gsub(/\\n/, " ").gsub(/\\t/, " ")
#tmp.puts hsh.to_json
tmp.close

results = `curl --silent -X PUT http://localhost:5984/#{database}/_design/example -d @tmp.js`
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
