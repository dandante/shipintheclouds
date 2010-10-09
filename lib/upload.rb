#!/usr/bin/env ruby


if ARGV.size != 3
  puts "usage: #{$0} file_list dir bucketname"
  exit
end

file_list, dir, bucketname = ARGV

f = File.open(file_list)


while (line = f.gets)
  next if line =~ /DS_Store/
  line.chomp!
  dest = line.gsub(/\.\//, "")
  line.gsub!(/^\./, dir)
  #puts line
  cmd = %Q(s3cmd.rb put "#{bucketname}:#{dest}" "#{line}")
  puts cmd
  system cmd
end
