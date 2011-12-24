#!/usr/bin/env ruby

require 'minitest/autorun'
require 'minitest/spec'

Dir[File.join(File.expand_path(File.dirname(__FILE__)), "hotspots", "**", "*_test.rb")].each do |file|
  require file
end
