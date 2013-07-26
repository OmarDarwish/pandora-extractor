require_relative "pandora/version"
require_relative "station"
require_relative "seed"

require 'nokogiri'
require 'open-uri'
require 'date'

module Pandora
  class User
  	attr_accessor :user, :stations
    @@BASE_URL = "http://feeds.pandora.com/feeds/people/"

  	def initialize(user)
      @user = email?(user) ? get_user_from_email(user) : user     
      @STATONS_URL = @@BASE_URL + "#{user}/stations.xml"
      @stations = parse_stations
  	end

  	def email? (user)
  		/.*@/ =~ user  		
  	end

  	def get_user_from_email(email)
  		email.strip!
  		email.match(/.*@/)[0].chop
  	end

    def each
      @stations.each {|station| yield station}
    end
    
    def parse_stations
      begin
        doc = Nokogiri::XML(open(@STATONS_URL))
        items = doc.xpath('//rss/channel/item')
        stations = []
        unless items.length == 0      
          items.each do |item|
            station = Station.new        
            #parse station xml
            station.title = item.xpath('title').text
            station.url = item.xpath('link').text
            station.description = item.xpath('description').text
            date = item.xpath('pubDate').text
            station.date = DateTime.parse(item.xpath('pubDate').text) unless date.empty?  #Quickmix station has no date    
            station.id = item.xpath('pandora:stationCode').text
            station.album_art_url = item.xpath('pandora:stationAlbumArtImageUrl').text
            station.seeds = parse_seeds item.xpath 'pandora:seeds'
            stations << station                   
          end        
        end      
        return stations
      rescue
        return nil #user is private or does not exist
      end
      
    end
    
    def parse_seeds(node)
      seeds = []
      artist_seeds = node.xpath 'pandora:artistSeed'
      song_seeds = node.xpath 'pandora:songSeed'
      
      #parse artist seeds
      artist_seeds.each do |seed|
        artist = seed.at_xpath('pandora:artist').text
        artist_seed = Seed::ArtistSeed.new(artist)
        seeds << artist_seed
      end

      #parse song seeds
      song_seeds.each do |seed|
        song = seed.at_xpath('pandora:song').text
        artist = seed.at_xpath('pandora:artist').text
        song_seed = Seed::SongSeed.new(song, artist)
        seeds << song_seed
      end

      return seeds
    end

    private :parse_seeds
  end
end