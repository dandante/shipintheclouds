require 'rubygems'
require 'iconv'
require 'unicode'

class String
  
  
  def to_ascii_old
    # split in muti-byte aware fashion and translate characters over 127
    # and dropping characters not in the translation hash
    #self.mb_chars.split('').collect { |c| (c[0] <= 127) ? c : translation_hash[c[0]] }.join
    self.split('').collect { |c| (c[0] <= 127) ? c : translation_hash[c[0]] }.join
  end
  
  
  def to_ascii
    out = ""
    bytes = []
    

    map ={236=>"I",
     225=>"a",
     214=>"O",
     203=>"E",
     192=>"A",
     253=>"y",
     242=>"o",
     231=>"c",
     220=>"U",
     209=>"N",
     198=>"AE",
     248=>"o",
     237=>"I",
     226=>"a",
     204=>"I",
     193=>"A",
     254=>"th",
     243=>"o",
     232=>"e",
     221=>"Y",
     210=>"O",
     199=>"C",
     249=>"u",
     238=>"I",
     227=>"a",
     216=>"O",
     205=>"I",
     194=>"A",
     255=>"y",
     244=>"o",
     233=>"e",
     222=>"TH",
     211=>"O",
     200=>"E",
     250=>"u",
     239=>"I",
     228=>"a",
     217=>"U",
     206=>"I",
     195=>"A",
     245=>"o",
     234=>"e",
     223=>"ss",
     212=>"O",
     201=>"E",
     251=>"u",
     240=>"o",
     229=>"a",
     218=>"U",
     207=>"I",
     196=>"A",
     246=>"o",
     235=>"e",
     224=>"a",
     213=>"O",
     202=>"E",
     252=>"u",
     241=>"n",
     230=>"ae",
     219=>"U",
     208=>"D",
     197=>"A"}
    
    self.each_byte {|b| bytes.push b}
    bytes.each_with_index do |b,i|
        #puts "b = #{b}, map[b] = #{map[b]}"
        if b > 127
          out += map[b] if map.has_key? b
        else
          out += b.chr
        end
    end
    out
    
  end
  
  def to_html_escaped
      out = ""
      bytes = []
      chars = []
      self.each_char {|c| chars.push c}
      self.each_byte {|b| bytes.push b}
      bytes.each_with_index do |b,i|
          if b > 127
            out += "&##{b.to_s};"
          else
            out += chars[i]
          end
      end
      out
  end
  
    
  def to_url_format
    url_format = self.to_ascii
    url_format = url_format.gsub(/[^A-Za-z0-9]/, '') # all non-word
    url_format.downcase!
    url_format
  end
  
  
  def foo
    accented_chars   = "ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝàáâãäåçèéêëìíîïñòóôõöøùúûüý".split('')
    unaccented_chars = "AAAAAACEEEEIIIIDNOOOOOxOUUUUYaaaaaaceeeeiiiinoooooouuuuy".split('')
    acc_range = [128..184]
    a = accented_chars
    a.each_with_index do |c,i|
      puts "#{c}  = #{a[i]}"
    end
    puts a
    nil
  end
  
  protected
  
    def translation_hash
      @@translation_hash ||= setup_translation_hash      
    end
    
    def setup_translation_hash
      #accented_chars   = "ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝàáâãäåçèéêëìíîïñòóôõöøùúûüý".mb_chars.split('')
      accented_chars   = "ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝàáâãäåçèéêëìíîïñòóôõöøùúûüý".split('')
      unaccented_chars = "AAAAAACEEEEIIIIDNOOOOOxOUUUUYaaaaaaceeeeiiiinoooooouuuuy".split('')
  
      translation_hash = {}
      accented_chars.each_with_index { |char, idx| translation_hash[char[0]] = unaccented_chars[idx] }
      #translation_hash["Æ".mb_chars[0]] = 'AE'
      translation_hash["Æ"[0]] = 'AE'
      #translation_hash["æ".mb_chars[0]] = 'ae'
      translation_hash["æ"[0]] = 'ae'
      translation_hash
    end
    
end

__END__
s = "Hüsker Dü"

puts "ascii = #{s.to_ascii}"
