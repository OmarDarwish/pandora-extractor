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
