require 'rake'
require 'rake/testtask'

#############################################

desc "Running Tests"
task :test do 
	Rake::TestTask.new do |t|
		t.libs.push "lib"
		t.test_files = FileList['test/test_*.rb']
	end
end

#############################################

spec    = "umatic.gemspec"
gemspec = eval(File.read(spec))
gemfile = "#{gemspec.full_name}.gem"

desc "Building Gem"
task :build => gemfile

file gemfile => gemspec.files + [spec] do
	`gem build #{spec}`
end

#############################################

desc "Installing Gem"
task :install => :build do
	`gem install #{gemfile}`
end

#############################################

task :default => [:test, :build, :install]
