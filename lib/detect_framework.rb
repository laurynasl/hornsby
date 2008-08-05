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

