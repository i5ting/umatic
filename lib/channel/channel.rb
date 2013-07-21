require 'open-uri'
require 'json'
require 'cgi'
require 'ostruct'
require File.expand_path('../../client.rb', __FILE__)

module Umatic
	class Channel
		def self.channels; @@channels; end

		def self.inherited(subclass)
			@@channels ||= []
			@@channels << subclass
		end

		def self.open(url)
			@@channels.each do |c|
				return c.new(url) if c.supports? url
			end
			nil
		end

		def self.supports? url
			false
		end

		def initialize(url)
			@url = url
		end

		def parse(page)
			raise "Parsing not implemented for #{self.class}"
		end

		def process
			page = HTTPClient.instance.get @url
			parse page
		end
		
		def download_webpage(url)
			HTTPClient.instance.get url
		end

		def resolve_url(url)
			HTTPClient.instance.open url
		end

	end
end
