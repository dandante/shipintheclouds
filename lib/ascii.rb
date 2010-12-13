class String 
  @@map = {}
  accented_chars   = "ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝàáâãäåçèéêëìíîïñòóôõöøùúûüý".split('')
      unaccented_chars = "AAAAAACEEEEIIIIDNOOOOOxOUUUUYaaaaaaceeeeiiiinoooooouuuuy".split('')
  accented_chars.each_with_index do |char, i|
    @@map[char] = unaccented_chars[i]
  end 
  @@map["Æ"] = 'AE'
  @@map["æ"] = 'ae'

require 'pp'

#pp @@map
#exit if true        
# MAP = [[/ü/, 'u'], 
#        [/ö/, 'o']] 
 def eng_char 
   res = String.new(self) 
   @@map.each { |r| res = res.gsub(r[0],r[1]) } 
   return res 
 end 
end 
s = "abücüöö" 

f = File.open("/Users/dante/Downloads/husker.txt")
s = f.readlines.join

s = "Æscii"
puts s + " => " + s.eng_char




class Ascii
end