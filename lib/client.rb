require 'net/http'
require 'uri'

module Umatic
	class HTTPClient

		def self.instance
			@@instance ||= new
		end

		def open(uri_str, limit = 2)
			raise 'HTTP redirect too deep' if limit == 0

			uri = URI.parse(uri_str)

			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = true if uri.scheme == "https"
			response = http.head(uri.path + '?' + (uri.query ? uri.query : ''))

			case response
			when Net::HTTPSuccess     then uri_str
			when Net::HTTPRedirection then open(response['location'], limit - 1)
			else
				response.error!
			end
		end

		def get(url)
			uri = open(url)
			Net::HTTP.get(URI.parse(uri))
		end

	end
end
