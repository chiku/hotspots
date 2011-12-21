#!/usr/bin/env ruby

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

  it "disregards file case" do
    lines = [
      "ABC.TXT"
    ]
    hotspot = Hotspot.new(lines)
    hotspot.on("abc.txt").must_equal 1
  end

  it "neglects empty lines" do
    lines = [
      " "
    ]
    hotspot = Hotspot.new(lines)
    hotspot.on(" ").must_equal 0
  end

  it "neglects spaces at the extremes of the line" do
    lines = [
      "  abc.txt  "
    ]
    hotspot = Hotspot.new(lines)
    hotspot.on("abc.txt").must_equal 1
  end

  it "neglects linefeeds at the extremes of the line" do
    lines = [
      "\n\n  abc.txt  \n\r",
      "\n\n  abc.txt  \r\n"
    ]
    hotspot = Hotspot.new(lines)
    hotspot.on("abc.txt").must_equal 2
  end

  it "has a string representation" do
    lines = [
      "abc.txt",
      "efg.txt"
    ]
    hotspot = Hotspot.new(lines)
    hotspot.to_s.must_equal <<-EOS
abc.txt,1
efg.txt,1
    EOS
  end

  it "string representation has maximum occuring string at the top" do
    lines = [
      "abc.txt",
      "abc.txt",
      "efg.txt",
      "efg.txt",
      "efg.txt"
    ]
    hotspot = Hotspot.new(lines)
    hotspot.to_s.must_equal <<-EOS
efg.txt,3
abc.txt,2
    EOS
  end

  it "doesn't display setting below cut-off" do
    lines = [
      "abc.txt",
      "abc.txt",
      "efg.txt",
      "efg.txt",
      "efg.txt"
    ]
    hotspot = Hotspot.new(lines, 3)
    hotspot.to_s.must_equal <<-EOS
efg.txt,3
    EOS
  end
end
