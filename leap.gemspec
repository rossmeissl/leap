# -*- encoding: utf-8 -*-
require File.expand_path("../lib/leap/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "leap"
  s.version     = Leap::VERSION
  s.authors     = ["Andy Rossmeissl", "Seamus Abshere", "Derek Kastner"]
  s.email       = "andy@rossmeissl.net"
  s.homepage    = "https://github.com/rossmeissl/leap"
  s.summary     = %Q{A heuristics engine for your Ruby objects}
  s.description = %Q{Leap to conclusions}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'charisma'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'bueller'
  s.add_dependency 'yard'
  s.add_dependency 'activesupport', '>=2.3.4'
  # sabshere 1/27/11 for activesupport - http://groups.google.com/group/ruby-bundler/browse_thread/thread/b4a2fc61ac0b5438
  s.add_dependency 'i18n'
end
