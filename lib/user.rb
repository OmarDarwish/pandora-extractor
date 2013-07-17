require_relative "pandora/version"
require 'nokogiri'
require 'open-uri'

module Pandora
  
  class User
  	attr_accessor :user

  	def initialize(user)
  		@user = get_user_from_email(user) if email? user else user
  	end

  	def email? (user)
  		/.*@/ =~ user  		
  	end

  	def get_user_from_email(email)
  		email.strip!
  		email.match(/.*@/)[0].chop
  	end

  end
end
