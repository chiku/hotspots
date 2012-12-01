# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)

require "hotspots/version"

Gem::Specification.new do |s|
  s.name                     = "hotspots"
  s.version                  = Hotspots::VERSION
  s.authors                  = ["Chirantan Mitra"]
  s.email                    = ["chirantan.mitra@gmail.com"]
  s.homepage                 = "https://github.com/chiku/hotspots"
  s.summary                  = "Find all files that changed over the past in a git repository based on conditions"
  s.description              = <<-EOS
Find all files that changed over the past days for a git repository. If the same file is modified over
and over again, it may require re-design. Watch out for file changes that don't have a corresponding
test change.
EOS
  s.rubyforge_project        = "hotspots"
  s.files                    = `git ls-files`.split("\n")
  s.test_files               = `git ls-files -- {test}/*`.split("\n")
  s.executables              = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths            = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
end
