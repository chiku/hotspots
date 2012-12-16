begin
  require 'simplecov'
  SimpleCov.start do
    add_filter "/test/"
  end
rescue LoadError
  puts "\nPlease install simplecov to generate coverage report!\n\n"
end

# eager load all files
Dir["lib/**/*.rb"].each do |file|
  require File.expand_path(file)
end


require 'minitest/autorun'
require 'minitest/spec'
