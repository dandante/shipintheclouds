class FixBlankTitles
  f = File.open "blankfiles.txt"
  lines = f.readlines
  for line in lines
    line.chomp!
    neww, old = line.split "|"
    song = Song.find_by_file(old)
    #puts song.file
    segs = neww.split("/")
    title = segs.last
    if neww =~ /\/far\// and title =~ /[0-9][0-9]-[0-9][0-9]-/
      title.gsub!(/[0-9][0-9]-[0-9][0-9]-/, "")
      title = title.split("-").first
    end
    if title =~ /In The Shadow Of Clinch Mountain/
      sgs = title.split(" - ")
      title = sgs.first
    end
    title.gsub!(/\.mp3$/i, "")
    puts "#{title} #### #{neww}"
    song.title = title
    song.save
  end
end