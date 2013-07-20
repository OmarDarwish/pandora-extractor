module Pandora
	class Station
		attr_accessor :title, :url, :description, :date, :id,
			:album_art_url, :seeds

		def initialize
			@title = nil
			@url = nil
			@description = nil
			@date = nil
			@id = nil
			@album_art_url = nil
			@seeds = []
		end

		def ==(other)
			return false unless other.instance_of? Station
			@id == other.id
		end
	end
end