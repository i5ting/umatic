# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'umatic'

Gem::Specification.new do |s|
  s.name            = "umatic"
  s.authors         = ["Nazar Kanaev"]
  s.email           = "nazar.kanaev@gmail.com"
  s.homepage        = "http://github.com/nkanaev/umatic"
  s.version         = Umatic::VERSION
  s.platform        = Gem::Platform::RUBY
  s.summary         = "umatic"
  s.description     = "CLI tool for video downloading"
	s.license         = "MIT"

	s.add_dependency "curl"
	s.add_development_dependency "minitest"

  s.files           = Dir["./**/*"].reject { |file| file =~ /\.\/(bin|log|pkg|script|spec|test|vendor)/ }
	s.test_files      = Dir["./test/*"]
  s.executables     = ["umatic"]
  s.require_paths   = ["lib"]
end
