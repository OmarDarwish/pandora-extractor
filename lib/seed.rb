module Pandora
	module Seed
		class ArtistSeed
			attr_accessor :artist

			def initialize(artist)
				@artist = artist
			end

			def ==(other)
				return false unless other.instance_of? ArtistSeed
				@artist == other.artist
			end
		end

		class SongSeed
			attr_accessor :song, :artist

			def initialize(song, artist)
				@song = song
				@artist = artist
			end

			def ==(other)
				return false unless other.instance_of? SongSeed
				@song == other.song && @artist == other.artist
			end
		end
	end
end