task :spec do
  require 'rake/runtest'
  require 'minitest/autorun'
  require 'minitest/spec'

  lib = File.expand_path(File.dirname(__FILE__) + '/lib')
  $LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)

  Dir[File.join(File.expand_path(File.dirname(__FILE__)), "test", "**", "*_test.rb")].each do |file|
    Rake.run_tests file
  end
end

task :default => [:spec]
