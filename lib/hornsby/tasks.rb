require File.dirname(__FILE__)+'/../hornsby'

env = []
if defined?(Merb)
  env = :merb_env
elsif defined?(Rails)
  env = :environment
end

namespace :hornsby do

  desc "Load the scenario named in the env var SCENARIO"
  task :scenario => env do
    raise "set SCENARIO to define which scenario to load" unless ENV['SCENARIO']
    ::Hornsby.load#(ENV['FILENAME'])
    #::Hornsby.orm = ENV['ORM'].to_sym if ENV['ORM']
    ::Hornsby.build(ENV['SCENARIO'].split(','), self)
  end
  
end
