gem_name = "hornsby"
gem_version = "0.0.1"

Gem::Specification.new do |s| 
  s.name = gem_name
  s.version = gem_version
  s.author = "Laurynas Liutkus"
  s.email = "laurynasl@gmail.com"
  s.homepage = "http://github.com/laurynasl/hornsby/"
  s.platform = Gem::Platform::RUBY
  s.summary = "Totally different fixtures replacement"
  s.files = [
    "lib/hornsby.rb",
    "lib/laurynasl-hornsby.rb",
    "lib/hornsby/tasks.rb",
    "README"
  ]
  s.require_path = "lib"
  s.autorequire = "name"
  s.test_files = [
    "spec/spec_helper.rb",
    "spec/hornsby_spec.rb"
  ]
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  s.add_dependency("rspec", ">= 1.1.4")
end
