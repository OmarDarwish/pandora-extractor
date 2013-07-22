require 'nokogiri'
module Pandora
	class Station
		attr_accessor :title, :url, :description, :date, :id,
			:album_art_url, :seeds, :likes

		def initialize(args={})
			@title = args[:title]
			@url = args[:url]
			@description = args[:description]
			@date = args[:args]
			@id = args[:id]
			@album_art_url = args[:album_art_url]
			@seeds = args[:seeds]
		end

		def ==(other)
			return false unless other.instance_of? Station
			@id == other.id
		end
	end
end