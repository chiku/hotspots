def load_all_tests
  require 'rake/runtest'
  require 'minitest/autorun'
  require 'minitest/spec'

  lib = File.expand_path(File.dirname(__FILE__) + '/lib')
  $LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)
end

def load_all_source_files
  Dir[File.join(File.expand_path(File.dirname(__FILE__)), "lib", "**", "*.rb")].each do |file|
    require file
  end
end

def run_all_tests
  Dir[File.join(File.expand_path(File.dirname(__FILE__)), "test", "**", "*_test.rb")].each do |file|
    Rake.run_tests file
  end
end

def require_simplecov
  begin
    require 'simplecov'

    SimpleCov.start do
      add_filter "/test/"
    end

  rescue LoadError
    $stderr.puts <<-EOS

Could bot generate coverage report since 'simplecov' is unavailable.
Please install simplecov and re-run to generate coverage report.
[sudo] gem install simplecov

  EOS
  end
end

task :test do
  load_all_tests
  run_all_tests
end

task :coverage do
  require_simplecov
  load_all_tests
  load_all_source_files
  run_all_tests
end

task :default => [:coverage]
