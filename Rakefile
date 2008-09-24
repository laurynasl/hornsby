require 'rubygems'
require 'rake'
require "rake/gempackagetask"

load 'hornsby.gemspec'

Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end 

desc "Run :package and install the resulting .gem"
task :install => :package do
  #sh install_command(GEM_NAME, GEM_VERSION)
  sh %{sudo gem install pkg/#{GEM_NAME}-#{GEM_VERSION} --no-update-sources}
end
