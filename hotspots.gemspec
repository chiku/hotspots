# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

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
  s.files                    = Dir.glob("{lib,bin,test}/**/*") + %w(LICENSE README.md CHANGELOG.md TODO.md)
  s.test_files               = Dir.glob("{test}/**/*")
  s.executables              = Dir.glob("{bin}/**/*").map{ |f| File.basename(f) }
  s.require_paths            = ["lib"]
  s.license                  = "MIT"

  s.add_dependency "ansi"

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest", ">= 4.2.0"
  s.add_development_dependency "simplecov"
end
