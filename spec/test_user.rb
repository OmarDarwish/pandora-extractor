require_relative '../lib/pandora'
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