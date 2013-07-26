require 'date'

module Pandora

  class Like
    attr_accessor :song, :artist, :date, :album
    
    def initialize(song, artist, album, date = DateTime.now)
      @song = song
      @artist = artist
      @album = album
      @date = date
    end

    def ==(other)
      return false unless other.instance_of? Like
      @song == other.song && @artist == other.artist
    end
       
  end
end