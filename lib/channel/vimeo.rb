$:.push File.expand_path('../', __FILE__)
require 'channel'

module Umatic
	class Vimeo < Channel
		def self.supports? url
			url.match(/https?:\/\/vimeo.com\/[\d+]{6,10}/)
		end

		def parse page
			page.delete!("\n")
			re = / = {config:(.+),assets:/
				json_match = page.match(re)
			raise "Unable to retrieve video info" unless json_match
			json = json_match[1]

			config = JSON.parse(json)
			title = config['video']['title']
			description = ''
			sources = []

			sig       = config['request']['signature']
			timestamp = config['request']['timestamp']
			video_id  = config['video']['id']

			files = config['video']['files']
			files.each do |codec, qualities|
				qualities.each do |quality|
					s = OpenStruct.new
					s.format = 'mp4'
					s.url = correct_url "http://player.vimeo.com/play_redirect?"\
						"clip_id=#{video_id}"\
					"&sig=#{sig}"\
					"&time=#{timestamp}"\
					"&quality=#{quality}"\
					"&codecs=#{codec.upcase}"\
					"&type=moogaloop_local"\
						"&embed_location=&seek=0"
					s.info = "#{codec} - #{quality}"
					sources << s
				end
			end

			{
				:title 				=> title,
				:description 	=> description,
				:sources			=> sources
			}
		end
		
		def correct_url(url)
			HTTPClient.instance.open(url)
		end
	end
end
