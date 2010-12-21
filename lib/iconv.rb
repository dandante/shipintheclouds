#!/usr/bin/env ruby

$KCODE = 'u'
require 'rubygems'
#require 'iconv'
require 'unicode'

s = "dan's music/the rock/Los Lobos/La Pistola y El Corazo\314\201n/03 Si Yo Quisiera.mp3"
s = %Q(d4ed7c40-b082-012d-db52-549a200f1604: "dan's music/the rock/Los Lobos/La Pistola y El Corazo\xCC\x81n/03 Si Yo Quisiera.mp3")

#ic_ignore = Iconv.new('US-ASCII//IGNORE', 'UTF-8')
#puts ic_ignore.iconv(s) # => caff

#ic_translit = Iconv.new('US-ASCII//TRANSLIT', 'UTF-8')
#puts ic_translit.iconv(s) # => caff`e

puts Unicode.normalize_KD(s).gsub(/[^\x00-\x7F]/n,'') 

puts Unicode.normalize_KD(s)#.gsub(/[^\x00-\x7F]/n,'') 