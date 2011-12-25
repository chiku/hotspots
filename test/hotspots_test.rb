#!/usr/bin/env ruby

require 'minitest/autorun'
require 'minitest/spec'

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)

Dir[File.join(File.expand_path(File.dirname(__FILE__)), "hotspots", "**", "*_test.rb")].each do |file|
  require file
end
