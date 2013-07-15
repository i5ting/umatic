module Umatic
  VERSION = '0.1'
end

$:.push File.expand_path('../', __FILE__)

require 'std/proc'
require 'channel/channel'
require 'channel/youtube'
require 'channel/vimeo'

module Umatic
	def self.open url
		Channel.open url
	end

	def self.supported_channels
		Channel.channels.map { |c| c.to_s.gsub(/Umatic::/, "") }
	end
	
end
