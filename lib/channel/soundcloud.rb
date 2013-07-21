$:.push File.expand_path('../', __FILE__)
require 'channel'
require 'json'

module Umatic
	class SoundCloud < Channel
		
		def self.supports?(url)
			url.match(/soundcloud.com\/.+\/.+/)
		end

		def process
			client_id = 'b45b1aa10f1ac2941910a7f0d10f8e28'
			resolve_url = "http://api.soundcloud.com/resolve.json?url=#{@url}&client_id=#{client_id}"
			resolve_page = download_webpage resolve_url
			return nil unless resolve_page

			info    = JSON.parse resolve_page
			id      = info['id']
			title   = info['title']
			description = info['description']
			sources = []

			# original download url
			if info['downloadable'] then
				original = OpenStruct.new
				original.format = info['original_format']
				original.info   = 'original'
				original.url    = resolve_url(info['download_url'] + "?client_id=#{client_id}")
				sources << original
			end

			# 128 kbps stream
			streams_url = "https://api.sndcdn.com/i1/tracks/#{id}/streams?client_id=#{client_id}"
			stream_json = download_webpage streams_url
			rip = OpenStruct.new
			rip.format = 'mp3'
			rip.info   = '128 kbps rip'
			rip.url    = JSON.parse(stream_json)['http_mp3_128_url']
			
			sources << rip

			result = OpenStruct.new
			result.id          = id
			result.title       = title
			result.description = description
			result.sources     = sources 
			result
		end
	end
end
