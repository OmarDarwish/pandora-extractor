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

describe User, '#get_stations' do

	it "should return an array of Pandora::Station objects" do
		user = User.new('om.drwsh')
		stations = user.get_stations
		stations.should have(9).stations #current number of statios for user om.drwsh as of 07/17/13
	end
	it "should return nil if the user has no satations" do
		user = User.new('omarfdarwish') #this account has no stations
		stations = user.get_stations
		stations.should be_instance_of(nil)
		
	end
	it "should return nil if the user does not exist" do
		user = User.new('thisuserdoesnotexist')
		stations = user.get_stations
		stations.should be_instance_of(nil)
	end
		
	it "should return nil if the user is private" do
		user = User.new('vuhoaipham22')
		stations = user.get_stations
		stations.should be_instance_of(nil)
	end
		

end