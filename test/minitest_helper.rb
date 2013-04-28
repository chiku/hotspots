lib = File.expand_path('../../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

if ENV["coverage"] == "true"
  begin
    require 'simplecov'
    SimpleCov.start do
      add_filter "/test/"
    end
  rescue LoadError
    puts "\nPlease install simplecov to generate coverage report!\n\n"
  end
end

# eager load all files
Dir["lib/**/*.rb"].each do |file|
  require File.expand_path(file)
end

require_relative "../lib/hotspots"

gem 'minitest'
require 'minitest/autorun'
