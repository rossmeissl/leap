# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "leap/version"

Gem::Specification.new do |s|
  s.name        = "leap"
  s.version     = Leap::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andy Rossmeissl", "Seamus Abshere"]
  s.email       = "andy@rossmeissl.net"
  s.homepage    = "http://github.com/rossmeissl/leap"
  s.summary     = %Q{A heuristics engine for your Ruby objects}
  s.description = %Q{Leap to conclusions}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
#  s.add_development_dependency "charisma"
  s.add_development_dependency "shoulda"
  s.add_dependency 'blockenspiel', '>=0.3.2'
  s.add_dependency 'activesupport', '>=2.3.4'
  # sabshere 1/27/11 for activesupport - http://groups.google.com/group/ruby-bundler/browse_thread/thread/b4a2fc61ac0b5438
  s.add_dependency 'i18n'
  s.add_dependency 'builder'
end
