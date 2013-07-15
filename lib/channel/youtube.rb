$:.push File.expand_path('../', __FILE__)
require 'channel'

module Umatic
	class Youtube < Channel
		def self.supports? url
			url.match(/http[s]?:\/\/www.youtube.com\/watch?.*v=.+/) != nil
		end

		QUALITY = {
			# low quality
			'5'  => { :f => 'flv',  :d => '240p' },
			'6'  => { :f => 'flv',  :d => '270p'},
			'13' => { :f => '3gp',  :d => 'N/A' },
			'17' => { :f => '3gp',  :d => '144p' },
			'18' => { :f => 'mp4',  :d => '360p' },

			# medium quality
			'34' => { :f => 'flv',  :d => '360p' },
			'35' => { :f => 'flv',  :d => '480p' },
			'43' => { :f => 'webm', :d => '360p' },
			'44' => { :f => 'webm', :d => '480p' },

			# high quality
			'22' => { :f => 'mp4',  :d => '720p' },
			'37' => { :f => 'mp4',  :d => '1080p' },
			'38' => { :f => 'mp4',  :d => '3072p' },
			'45' => { :f => 'webm', :d => '720p' },
			'46' => { :f => 'webm', :d => '1080p'  }
		}

		def parse page
			json_match = page.match(/<script>.+ytplayer.config = (.+).+?<\/script>/)
			raise "Unable to retrieve video info" unless json_match
			info = JSON::parse json_match[1]

			title = info['args']['title']
			description = ''
			sources = []

			maps = info["args"]["url_encoded_fmt_stream_map"]
			maps.split(',').each do |m|
				params = CGI::parse(m)
				params.each { |k, v| params[k] = v[0] }
				itag = params['itag']
				next unless QUALITY.keys.include?(itag)

				s = OpenStruct.new
				s.format = QUALITY[itag][:f]
				s.info   = QUALITY[itag][:d]
				s.url    = "#{params['url']}&signature=#{params['sig']}"
				sources << s
			end

			{
				:title => title,
				:description => description,
				:sources => sources
			}
		end
	end
end
