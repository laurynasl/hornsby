require File.dirname(__FILE__)+'/../lib/hornsby'

namespace :hornsby do

  desc "Load the scenario named in the env var SCENARIO"
  task :scenario => :environment do
    raise "set SCENARIO to define which scenario to load" unless ENV['SCENARIO']
    ::Hornsby.load(ENV['FILENAME'])
    ::Hornsby.orm = ENV['ORM'].to_sym if ENV['ORM']
    ::Hornsby.build(ENV['SCENARIO'].split(','), self)
  end
  
end
