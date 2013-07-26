require_relative 'like'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'debugger'

module Pandora
	class Station
		attr_accessor :title, :url, :description, :date, :id,
			:album_art_url, :seeds
		attr_reader :likes

		@@BASE_URL = 'http://www.pandora.com/content/station_track_thumbs'
		@@HOMEPAGE = 'http://www.pandora.com'

		def initialize(args={})
			@title = args[:title]
			@url = args[:url]
			@description = args[:description]
			@date = args[:args]
			@id = args[:id]
			@album_art_url = args[:album_art_url]
			@seeds = args[:seeds]
			@like_index = args[:like_index] || 0
		end

		def each
			@likes.each {|like| yield like}
		end

		def parse_likes
			return nil if quickmix?
			@likes = []
			while grabbed = next_likes
				grabbed.each {|like| @likes << like}
				@like_index += grabbed.length
			end			
			return @likes
		end

		def next_likes
			#attempt to open page
			begin
				url = @@BASE_URL + Station.encode_query(@like_index, Station.filter_id(@id))
				doc = Nokogiri::HTML open(url)
			rescue
				return nil
			end

			#parse songs
			songs = doc.css('a:nth-child(1)')
			#filter out empty items
			songs = songs.select do |item|
				str = item.text
				item unless str.empty? || str.nil?
			end
			#parse out album links from songs
			albums = songs.collect {|song| song[:href]}
			albums = albums.collect {|link| parse_album(@@HOMEPAGE + link)}

			#only save song text
			songs.collect! {|song| song.text}

			#parse artists
			artists = doc.css('a:nth-child(2)')
			artists = artists.collect {|artist| artist.text}

			#parse dates
			dates = doc.css('.col2')
			dates = dates.collect {|date| date.text}

			#collect all attributes
			col = songs.zip artists, albums, dates
			unless col.length == 0
				likes = []
				col.each do |song, artist, album, date|
					like = Like.new song, artist, album, parse_date(date)
					likes << like
				end
				return likes
			end
			#no likes found
			return nil			
		end		

		def parse_album(url)
			#attempt to open page
			begin
				doc = Nokogiri::HTML(open(url))
				uri = URI(url)				
			rescue
				return nil
			end
			 return doc.css('.album_title').first.text.gsub(/\Aon\s/,' ').strip #strip "on  " from album text
			#album not found
			return nil
		end

		def parse_date(date)
			Date.strptime(date, "%m-%d-%Y")
		end

		def ==(other)
			return false unless other.instance_of? Station
			@id == other.id
		end

		def quickmix?
			/qm/ =~ @id
		end

		def self.encode_query(index, id, op={})
			op[:stationId] ||= id
			op[:posFeedbackStartIndex] ||= index
			op[:posSortAsc] ||= 'true'
			op[:posSortBy] ||= 'date'
			return '?' + op.map { |k,v| "#{k}=#{v}"  }.join('&')
		end

		def self.filter_id(str)
			sub = str.gsub 'sh', ''
		end

	end
end