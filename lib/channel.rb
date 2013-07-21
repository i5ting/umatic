require 'open-uri'
require 'json'
require 'cgi'
require 'ostruct'
require 'net/http'
require 'uri'

module Umatic
	class Channel

		def self.channels; @@channels ||= []; end

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
		
		def self.name
			self.to_s.split('::').last || ''
		end

		def process
			raise "Process method not implemented for #{self.class}"
		end

		def resolve_url(url, limit = 2)
			raise 'HTTP redirect too deep' if limit == 0

			uri = URI.parse(url)

			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = true if uri.scheme == "https"
			response = http.head(uri.path + '?' + (uri.query ? uri.query : ''))

			case response
			when Net::HTTPSuccess     then url
			when Net::HTTPRedirection then resolve_url(response['location'], limit - 1)
			else
				response.error!
			end
		end

		def download_webpage(url)
			uri = resolve_url(url)
			Net::HTTP.get(URI.parse(uri))
		end

	end
end

Dir[File.expand_path('../channel/*.rb', __FILE__)].each { |f| require f }
