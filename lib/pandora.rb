require_relative "pandora/version"
require 'nokogiri'

module Pandora
  
  class Base

  	def initialize(user = nil)
  		@user = user
  	end

  end
end
