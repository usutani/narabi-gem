# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "narabi/version"

Gem::Specification.new do |s|
  s.name        = "narabi"
  s.version     = Narabi::VERSION
  s.authors     = ["Yasuhiro Usutani"]
  s.email       = ["y_usutani@me.com"]
  s.homepage    = ""
  s.summary     = %q{Sequence text parser}
  s.description = %q{Sequence text parser}

  s.rubyforge_project = "narabi"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_development_dependency "cucumber"
end
