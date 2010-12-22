class MassageAfterImporting
  
require "#{RAILS_ROOT}/lib/toascii.rb"
require 'pp'

  text_columns = %w{album artist comments genre genre_s title file}


  
#  for column in text_columns
#    query = "update songs set #{column} = NULL where #{column} = 'null'"
#    Song.connection.execute query
#    puts query
#  end



# populate *_c columns
# todo - add code that only does this for newly imported rows
 
 songs = Song.find :all
 max = songs.length
 songs.each_with_index do |song, i|
   for column in text_columns
     next if song.send(column).nil?
     clearcol = "#{column}_c"
     clearcol_setter = "#{clearcol}="
     song.send(clearcol_setter, song.send(column).unaccented) 
   end
   #pp song
   puts "#{i+1}/#{max}"
   song.save
 end 
  
end

