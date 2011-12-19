require 'minitest/autorun'
require 'minitest/spec'

require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'hotspot.rb')

describe "Hotspot test" do
  it "counts occurances of a line present once" do
    lines = [
      "abc.txt",
      "efg.txt"
    ]
    hotspot = Hotspot.new(lines)
    hotspot.on("abc.txt").must_equal 1
    hotspot.on("efg.txt").must_equal 1
  end

  it "counts occurances of a line present multiple times" do
    lines = [
      "abc.txt",
      "abc.txt",
      "efg.txt"
    ]
    hotspot = Hotspot.new(lines)
    hotspot.on("abc.txt").must_equal 2
  end

  it "identifies zero occurances" do
    lines = [
      "abc.txt",
      "efg.txt"
    ]
    hotspot = Hotspot.new(lines)
    hotspot.on("absent.txt").must_equal 0
  end
end
