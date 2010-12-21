class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table(:songs) do |t|
      t.column :uuid, :text
      t.column :album, :text
      t.column :artist, :text
      t.column :comments, :text
      t.column :genre, :text
      t.column :genre_s, :text
      t.column :length, :integer
      t.column :title, :text
      t.column :tracknum, :integer
      t.column :year, :integer
      t.column :file, :text
      t.column :indexed_at, :integer 
      
      
      ###
      t.column :hidden, :boolean
      
      ###
      t.column :album_c, :text
      t.column :artist_c, :text
      t.column :comments_c, :text
      t.column :genre_c, :text
      t.column :genre_s_c, :text
      t.column :title_c, :text
      t.column :file_c, :text
      
      
      
    end
  end

  def self.down
    drop_table :songs
  end
end

__END__

http://stackoverflow.com/questions/455606/how-to-import-file-into-sqlite

CREATE TABLE songs_import(
uuid text,
album text,
artist text,
comments text, 
genre text,
genre_s text, 
length integer,
title text,
tracknum integer,
year integer,
file text,
indexed_at integer
);


insert into songs (uuid, album, artist, comments, genre, genre_s, length, title, tracknum, year, file, indexed_at) select * from songs_import;

( drop table songs_import)