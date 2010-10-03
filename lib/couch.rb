#see http://wiki.apache.org/couchdb/Getting_started_with_Ruby

require 'net/http'

module Couch

  class Server
    def initialize(host, port, options = nil)
      @host = host
      @port = port
      @options = options
    end

    def delete(uri)
      request(Net::HTTP::Delete.new(uri))
    end

    def get(uri)
      request(Net::HTTP::Get.new(uri))
    end

    def put(uri, json)
      req = Net::HTTP::Put.new(uri)
      req["content-type"] = "application/json"
      req.body = json
      request(req)
    end

    def post(uri, json)
      req = Net::HTTP::Post.new(uri)
      req["content-type"] = "application/json"
      req.body = json
      request(req)
    end

    def request(req)
      res = Net::HTTP.start(@host, @port) { |http|http.request(req) }
      unless res.kind_of?(Net::HTTPSuccess)
        handle_error(req, res)
      end
      res
    end

    private

    def handle_error(req, res)
      e = RuntimeError.new("#{res.code}:#{res.message}\nMETHOD:#{req.method}\nURI:#{req.path}\n#{res.body}")
      raise e
    end
  end
end

__END__

Creating a Database

To create a database called foo:


server = Couch::Server.new("localhost", "5984")
server.put("/foo/", "")
Deleting a Database

To delete a database called foo:


server = Couch::Server.new("localhost", "5984")
server.delete("/foo")
Creating a Document

To create a document in the database foo with the id document_id:


server = Couch::Server.new("localhost", "5984")
doc = <<-JSON
{"type":"comment","body":"First Post!"}
JSON
server.put("/foo/document_id", doc)
Reading a Document

To read a document from database foo with the id document_id:


server = Couch::Server.new("localhost", "5984")
res = server.get("/foo/document_id")
json = res.body
puts json
Getting_started_with_Ruby (last edited 2010-04-08 16:50:26 by SebastianCohnen)
