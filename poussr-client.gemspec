# -*- coding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "poussr-client"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Frédérick Ros"]
  s.email       = ["frederick.ros@gmail.com"]
  s.homepage    = "http://github.com/sleeper/poussr-client"
  s.summary     = %q{Poussr client}
  s.description = %q{Wrapper for the Poussr REST API, avoid to recode it manually :). It is *heavily* inspired on the pusherapp-gem client.}
  
  s.add_dependency "json", "~> 1.4.0"
  # s.add_dependency "crack", "~> 0.1.0"
  # s.add_dependency "ruby-hmac", "~> 0.4.0"
  # s.add_dependency 'signature', "~> 0.1.2"
  
  s.add_development_dependency "rspec", "~> 2.0"
  s.add_development_dependency "webmock"
  # s.add_development_dependency "em-http-request", "~> 0.2.7"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
