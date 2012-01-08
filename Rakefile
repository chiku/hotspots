def load_all_tests
  require 'rake/runtest'
  require 'minitest/autorun'
  require 'minitest/spec'

  lib = File.expand_path(File.dirname(__FILE__) + '/lib')
  $LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)
end

def run_all_tests
  Dir[File.join(File.expand_path(File.dirname(__FILE__)), "test", "**", "*_test.rb")].each do |file|
    Rake.run_tests file
  end
end

task :test do
  load_all_tests
  run_all_tests
end

task :coverage do
  require 'simplecov'

  SimpleCov.start do
    add_filter "/test/"
  end

  load_all_tests

  Dir[File.join(File.expand_path(File.dirname(__FILE__)), "lib", "**", "*.rb")].each do |file|
    require file
  end

  run_all_tests
end

task :default => [:coverage]
