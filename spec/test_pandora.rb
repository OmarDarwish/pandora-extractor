require_relative '../lib/pandora'
include Pandora

describe Base, '#new' do
	context "without user specified" do
		it "should create a Pandora::Base object" do
			pandora = Base.new
			pandora.should be_an_instance_of Base
		end
	end
	context "with user specified" do
		it "should create a Pandora::Base object with user set to argument"
	end
	context "with user specified being private" do
		it "should raise an exception"
	end
end