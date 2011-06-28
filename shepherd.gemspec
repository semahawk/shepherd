# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)

require "shepherd/version"

Gem::Specification.new do |s|
  s.name        = "shepherd"
  s.version     = Shepherd::Version::STRING
  s.authors     = ["Szymon Urbaś"]
  s.email       = ["szymon.urbas@yahoo.com"]
  s.homepage    = "http://github.com/semahawk/shepherd"
  s.summary     = %q{Be a shepherd to your projects}
  s.description = %q{Check if/how your projects are growing up!}
  s.date        = Time.now.strftime('%Y-%m-%d')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
