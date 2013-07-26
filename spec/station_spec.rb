require_relative "../lib/station"
include Pandora

describe Station, '#new' do
  it "should create a Station object" do
    station = Station.new
    station.should be_instance_of(Station)
  end

  it "should accept options" do
  	station = Station.new id: "123", title: "test station", url: "http://test.com"
  	station.id.should == "123"
  	station.title.should == "test station"
  	station.url.should == "http://test.com"
  	station.seeds.should == nil
  	station.description.should == nil
  end
end

describe Station, '#==' do
	context "Stations have same id" do
	 	it "should return true" do
	    	first = Station.new id: "test1234", title: "A radio station"	    	
	    	second = Station.new id: "test1234", title: "The same radio station"
	    	first.should == second
	  	end
	end

	context "Stations do not have same id" do
		it "should not return true" do
			first = Station.new id: "test123", title: "title", description: "description"
			second = Station.new id: "test345", title: "title", description: "description"
			first.should_not equal(second)
		end
	end
end

describe Station, '::encode_query' do
  it "should encode the URI query with given index and station id" do
    encoded = Station.encode_query 0, '1456242794242861817'
    premade = "?stationId=1456242794242861817&posFeedbackStartIndex=0&posSortAsc=true&posSortBy=date"
    encoded.should == premade
  end
end


describe Station, '::filter_id' do
  it "returns a filtered id string" do
    Station.filter_id('sh1456242794242861817').should == '1456242794242861817'
  end
end

describe Station, '#quickmix?' do
  it "should return true if this is a quickmix station" do
    station = Station.new id: 'qm428960505'
    station.quickmix?.should be_true
  end
end

describe Station, '#next' do
  it "each like should have song, album, artist, and date" do
    station = Station.new id: 'sh1456242794242861817'
    station.next.each do |like|
      like.song.should_not be_nil
      like.album.should_not be_nil
      like.artist.should_not be_nil
      like.date.should_not be_nil
    end
  end 
  it "should return an array of Likes" do
    station = Station.new id: 'sh1456242794242861817'
    likes = station.next
    likes.each {|like| like.should be_instance_of Like}
  end
  it "should return nil if no more tracks retrieved" do
    station = Station.new id: 'sh1456242794242861817', like_index: 1000
    station.next.should be_nil  
  end
end

describe Station, '#parse_album' do 
  it "should return album name" do
    station = Station.new
    parsed = station.parse_album 'http://www.pandora.com/pitch-perfect-film-cast/pitch-perfect-original-motion-picture-soundtrack/cups'
    actual = 'Pitch Perfect (Original Motion Picture Soundtrack)'
    parsed.should == actual
  end
end

describe Station, '#parse_likes' do
  it "should return all Likes for a given station" do
    station = Station.new id: 'sh1456242794242861817'
    station.parse_likes.should have(25).likes
  end   
end