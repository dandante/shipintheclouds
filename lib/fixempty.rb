class Fixempty
  
  songs = Song.find :all
  
  for song in songs
    attrs = song.attributes
    attrs.each_pair do |k,v|
      if (!v.nil? and v.to_s == "empty")
        meth = "#{k}="
        song.send(meth, nil)
        puts "id: #{song.id}: changing #{k} from #{v}"
        song.save
      end
    end
  end
end