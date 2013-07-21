module Umatic
  VERSION = '0.2'
end

$:.push File.expand_path('../', __FILE__)

require 'channel'

module Umatic

	def self.open url
		Channel.open url
	end

	def self.supported_channels
		Channel.channels.map { |c| c.name }
	end

end
