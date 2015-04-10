lib = File.expand_path("../../lib/", __FILE__)
$:.unshift lib unless $:.include?(lib)

require "ansi/code"

if ENV["coverage"] == "true"
  begin
    require "codeclimate-test-reporter"
    CodeClimate::TestReporter.start
  rescue LoadError
    $stderr.puts ::ANSI::Code.red("Please install codeclimate-test-reporter to generate a coverage report!")
  end

  begin
    require "simplecov"
    SimpleCov.start do
      add_filter "/test/"
    end
  rescue LoadError
    $stderr.puts ::ANSI::Code.red("Please install simplecov to generate a coverage report!")
    exit 1
  end
end

# eager load all files
Dir["lib/**/*.rb"].each do |file|
  require File.expand_path(file)
end

require_relative "../lib/hotspots"

gem "minitest"
require "minitest/autorun"
