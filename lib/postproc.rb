#!/usr/bin/env ruby

$KCODE = 'u'
map = {}


@map = {["A", "80"] => "A\xCC\x80",
 ["A", "81"] => "A\xCC\x81",
 ["A", "83"] => "A\xCC\x83",
 ["C", "8C"] => "C\xCC\x8C",
 ["E", "81"] => "E\xCC\x81",
 ["O", "88"] => "O\xCC\x88",
 ["U", "88"] => "U\xCC\x88",
 ["a", "80"] => "a\xCC\x80",
 ["a", "81"] => "a\xCC\x81",
 ["a", "83"] => "a\xCC\x83",
 ["a", "82"] => "a\xCC\x82",
 ["a", "88"] => "a\xCC\x88",
 ["c", "A7"] => "c\xCC\xA7",
 ["c", "8C"] => "c\xCC\x8C",
 ["e", "80"] => "e\xCC\x80",
 ["e", "81"] => "e\xCC\x81",
 ["e", "82"] => "e\xCC\x82",
 ["e", "88"] => "e\xCC\x88",
 ["i", "81"] => "i\xCC\x81",
 ["n", "83"] => "n\xCC\x83",
 ["o", "80"] => "o\xCC\x80",
 ["o", "81"] => "o\xCC\x81",
 ["o", "82"] => "o\xCC\x82",
 ["o", "83"] => "o\xCC\x83",
 ["o", "88"] => "o\xCC\x88",
 ["s", "8C"] => "s\xCC\x8C",
 ["u", "81"] => "u\xCC\x81",
 ["u", "88"] => "u\xCC\x88"}
 
def fix(one,two)
  @map[[one,two]]
end
regex = Regexp::new(/(.)\\xCC\\x(..)/)

f = File.open(ARGV.first)
while (line = f.gets)
  if line =~ regex
    results = line.scan(regex)
    for item in results
      one,two = item
      line.sub!(/#{one}\\xCC\\x#{two}/, fix(one,two))
    end
  end
  puts line
end