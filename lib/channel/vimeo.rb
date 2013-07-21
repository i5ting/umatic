module Umatic
	class Vimeo < Channel
		def self.supports? url
			url.match(/https?:\/\/vimeo.com\/[\d+]{6,10}/)
		end

		def process
			page = download_webpage @url

			re = / = {config:(.+),assets:/m
				json_match = page.match(re)
			return nil unless json_match
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
					s.url = resolve_url "http://player.vimeo.com/play_redirect?"\
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

			result = OpenStruct.new
			result.title       = title
			result.description = description
			result.sources     = sources
			result
		end
		
	end
end
