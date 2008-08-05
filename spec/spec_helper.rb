require 'rubygems'
require 'fileutils'

# detect framework
RAILS_CONFIG = File.dirname(__FILE__) + '/../../../../config/environment.rb'
MERB_CONFIG = File.dirname(__FILE__) + '/../../../config/init.rb'

if File.exists?(RAILS_CONFIG)
  FRAMEWORK = :rails
elsif File.exists?(MERB_CONFIG)
  FRAMEWORK = :merb
else
  raise "No framework detected"
end

if FRAMEWORK == :rails
  #ORM = :activerecord

  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'


elsif FRAMEWORK == :merb
  #ORM = :datamapper # just assumption for now...

  require File.dirname(__FILE__) + '/../../../spec/spec_helper'
  require 'activerecord'
end

plugin_spec_dir = File.dirname(__FILE__)

ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

databases = YAML::load(IO.read(plugin_spec_dir + "/db/database.yml"))

db_info = databases[ENV["DB"] || "sqlite3"]
puts db_info.inspect

#FileUtils::rm(RAILS_ROOT+"/"+db_info[:dbfile])

ActiveRecord::Base.establish_connection(db_info)

load(File.join(plugin_spec_dir, "db", "schema.rb"))
