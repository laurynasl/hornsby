#require File.dirname(__FILE__) + '/detect_framework'
require 'yaml'

if defined?(Merb::Plugins)
  Merb::Plugins.add_rakefiles "hornsby" / "tasks"
end

class Hornsby
  @@record_name_fields = %w( name title username login )
  @@delete_sql = "DELETE FROM %s"
  
  cattr_reader :scenarios
  cattr_accessor :tables_to_delete
  cattr_accessor :orm
  @@scenarios = {}
  
  def self.build(names, receiver_context)
    delete_tables

    context = Module.new
    ivars = context.instance_variables
    @@completed_scenarios = []

    names.each do |name|
      scenario = @@scenarios[name.to_sym] or raise "scenario #{name} not found"
      scenario.build(context)
    end

    context_ivars = context.instance_variables - ivars
    context_ivars.each do |iv|
      receiver_context.instance_variable_set(iv, context.instance_variable_get(iv))
    end
  end
  
  def self.[](name)
  end
  
  #def self.load(scenarios_file=nil)
  def self.load
    return unless @@scenarios.empty?

    root = if defined?(RAILS_ROOT)
      RAILS_ROOT
    elsif defined?(Rails)
      Rails.root.to_s
    elsif defined?(Merb)
      Merb.root.to_s
    else
      raise "giving up to find root"
    end
    
    if File.exists?('.hornsby')
      config = YAML.load(IO.read('.hornsby'))
      scenarios_file = config['filename']
      @@orm = config['orm'].to_sym if config['orm']
      @@tables_to_delete = config['tables_to_delete'].collect {|t| t.to_sym} if config['tables_to_delete']
    else
      #scenarios_file ||= root+'/spec/hornsby_scenarios.rb'
      File.open('.hornsby', 'w') do |f|
        f.write "orm: sequel\n"
        f.write "filename: hornsby_scenarios.rb\n"
        f.write "tables_to_delete: []\n"
      end
      puts "generated Hornsby configuration file at .hornsby"

      if File.exists?('hornsby_scenarios.rb')
        puts "looks like file hornsby_scenarios.rb exists"
      else
        File.open('hornsby_scenarios.rb', 'w') do |f|
          f.write "# for more information, see http://github.com/laurynasl/hornsby/wikis/usage\n"
          f.write "scenario :sample do\n"
          f.write "  \#@sample = SomeModel.create :name => \"Me\"\n"
          f.write "end\n"
        end
        puts "created sample scenarios file at hornsby_scenarios.rb"
      end
      exit
    end

    
    self.module_eval File.read(scenarios_file)
  end
  
  def self.scenario(scenario,&block)
    self.new(scenario, &block)
  end
  
  def self.namespace(name,&block)
  end
  
  def self.reset!
    @@scenarios = {}
  end
  
  def initialize(scenario, &block)
    case scenario
    when Hash
      parents = scenario.values.first
      @parents = Array === parents ? parents : [parents]
      scenario = scenario.keys.first
    when Symbol, String
      @parents = []
    else 
      raise "I don't know how to build `#{scenario.inspect}'"
    end
    
    @scenario = scenario.to_sym
    @block    = block
    
    @@scenarios[@scenario] = self
  end
  
  def say(*messages)
    puts messages.map { |message| "=> #{message}" }
  end

  def build(context)
    #say "Building scenario `#{@scenario}'"
    
    build_parent_scenarios(context)
    build_scenario(context)
    
    self
  end
  
  def build_scenario(context)
    return if @@completed_scenarios.include?(@scenario)
    surface_errors { context.module_eval(&@block) }
    @@completed_scenarios << @scenario
  end
  
  def build_parent_scenarios(context)
    @parents.each do |p|
      parent = self.class.scenarios[p] or raise "parent scenario [#{p}] not found!"

      parent.build_parent_scenarios(context)
      parent.build_scenario(context)
    end
  end

  
  def surface_errors
    yield
  rescue Object => error
    puts 
    say "There was an error building scenario `#{@scenario}'", error.inspect
    puts 
    puts error.backtrace
    puts 
    raise error
  end
  
  def self.delete_tables
    if @@orm == :activerecord
      tables.each { |t| ActiveRecord::Base.connection.delete(@@delete_sql % t)  }
    elsif @@orm == :datamapper
      DataMapper::Resource.descendants.each do |klass|
        #klass.auto_migrate!
        klass.all.destroy!
      end
    elsif @@orm == :sequel
      tables = (Sequel::Model.db.tables - [:schema_info])
      tables = (@@tables_to_delete||[]) + (tables - (@@tables_to_delete||[]))
      tables.each do |t|
        Sequel::Model.db << (@@delete_sql % t)
      end
    else
      raise "Hornsby.orm must be set to either :activerecord, :datamapper or :sequel"
    end
  end

  def self.tables
    ActiveRecord::Base.connection.tables - skip_tables
  end

  def self.skip_tables
    %w( schema_info )
  end
end


module HornsbySpecHelper
  def hornsby_scenario(*names)
    Hornsby.build(names, self)
  end
end
Hornsby.orm = :activerecord
