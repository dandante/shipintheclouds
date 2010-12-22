class Startmeup < ActiveRecord::Migration
  def self.up
    
  end

  def self.down
  end
end

__END__

insert into songs (_id, album, artist, comments, file,
 genre, genre_s, length, title, tracknum, year, indexed_at)
values (
:_id, :album, :artist, :comments, :file,
:genre, :genre_s, :length, :title, :tracknum, :year, :indexed_at
)
