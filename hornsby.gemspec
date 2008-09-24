require "rake/gempackagetask"
GEM_NAME = "hornsby"
GEM_VERSION = "0.0.1"

spec = Gem::Specification.new do |s| 
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.author = "Laurynas Liutkus"
  s.email = "laurynasl@gmail.com"
  s.homepage = "http://github.com/laurynasl/hornsby/"
  s.platform = Gem::Platform::RUBY
  s.summary = "Totally different fixtures replacement"
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.autorequire = "name"
  s.test_files = FileList["spec/*.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  s.add_dependency("rspec", ">= 1.1.4")
end
