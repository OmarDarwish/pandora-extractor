require_relative '../lib/user'

include Pandora

describe User, '#new' do	
		
		it "should require a username be passed" do
			lambda { pandora = User.new }.should raise_exception
		end

		it "should accept emails as usernames" do
			user = User.new('om.drwsh@gmail.com')
			user.user.should eql 'om.drwsh'
		end	
	
end

describe User, '#parse_stations' do

	it "should return an array of Pandora::Station objects" do
		user = User.new('om.drwsh')
		user.stations.should have(12).stations #current number of statios for user om.drwsh as of 07/17/13
	end
	it "should return an empty array if the user has no stations" do
		user = User.new('omarfdarwish') #this account has no stations
		user.stations.should have(0).stations		
	end
	it "should return nil if the user does not exist" do
		user = User.new('thisuserdoesnotexist')
		user.stations.should == nil
	end
		
	it "should return nil if the user is private" do
		user = User.new('vuhoaipham22')
		user.stations.should == nil
	end
end

describe User, "#parse_seeds" do
  	it "should return an array of Seed::ArtistSeed and Seed::SongSeed" do
  		user = User.new('om.drwsh')
  		doc = Nokogiri::XML(open('http://feeds.pandora.com/feeds/people/om.drwsh/stations.xml'))
  		node = doc.xpath('//rss/channel/item/pandora:seeds').first
  		parsed = user.send(:parse_seeds, node)
  		#manually create seeds, valid as of 07/19/2013
  		seeds = []
  		seed = Seed::SongSeed.new "I Need Your Love", "Calvin Harris"
  		seeds << seed
  		seed = Seed::ArtistSeed.new "Daft Punk"
  		seeds << seed
  		seed = Seed::ArtistSeed.new "Avicii"
  		seeds << seed
  		seed = Seed::SongSeed.new "She Doesn't Mind", "Sean Paul"
  		seeds << seed
  		parsed.should =~ seeds
  	end
end

