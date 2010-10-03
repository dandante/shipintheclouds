#!/usr/bin/env ruby

f = File.open("file_list.txt")

dir = "/Volumes/music from molly august 2010"

while (line = f.gets)
  next if line =~ /DS_Store/
  line.chomp!
  dest = line.gsub(/\.\//, "")
  line.gsub!(/^\./, dir)
  #puts line
  cmd = %Q(s3cmd.rb put "music19671025:#{dest}" "#{line}")
  puts cmd
  system cmd
end
