require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'minitest_helper')

class Hotspots
  describe "Store" do
    it "counts occurances of a line present once" do
      lines = [
        "abc.txt",
        "efg.txt"
      ]
      store = Store.new(lines)
      store.on("abc.txt").must_equal 1
      store.on("efg.txt").must_equal 1
    end

    it "counts occurances of a line present multiple times" do
      lines = [
        "abc.txt",
        "abc.txt",
        "efg.txt"
      ]
      store = Store.new(lines)
      store.on("abc.txt").must_equal 2
    end

    it "identifies zero occurances" do
      lines = [
        "abc.txt",
        "efg.txt"
      ]
      store = Store.new(lines)
      store.on("absent.txt").must_equal 0
    end

    it "neglects empty lines" do
      lines = [
        " "
      ]
      store = Store.new(lines)
      store.on(" ").must_equal 0
    end

    it "neglects spaces at the extremes of the line" do
      lines = [
        "  abc.txt  "
      ]
      store = Store.new(lines)
      store.on("abc.txt").must_equal 1
    end

    it "neglects linefeeds at the extremes of the line" do
      lines = [
        "\n\n  abc.txt  \n\r",
        "\n\n  abc.txt  \r\n"
      ]
      store = Store.new(lines)
      store.on("abc.txt").must_equal 2
    end

    it "has a string representation" do
      lines = [
        "abc.txt",
        "efg.txt"
      ]
      store = Store.new(lines)
      store.to_s.must_equal "abc.txt,1\nefg.txt,1\n"
    end

    it "has a case-sensitive string representation" do
      lines = [
        "aBc.tXt"
      ]
      store = Store.new(lines)
      store.to_s.must_equal "aBc.tXt,1\n"
    end

    it "string representation has maximum occuring string at the top" do
      lines = [
        "abc.txt",
        "abc.txt",
        "efg.txt",
        "efg.txt",
        "efg.txt"
      ]
      store = Store.new(lines)
      store.to_s.must_equal "efg.txt,3\nabc.txt,2\n"
    end

    it "doesn't display setting below cut-off" do
      lines = [
        "abc.txt",
        "abc.txt",
        "efg.txt",
        "efg.txt",
        "efg.txt"
      ]
      store = Store.new(lines, :cutoff => 3)
      store.to_s.must_equal "efg.txt,3\n"
    end

    it "doesn't display lines that don't match criteria" do
      lines = [
        "abc.txt",
        "abc.txt",
        "abc.txt",
        "dont.exist",
        "abc.log",
        "efg.txt",
        "efg.txt",
        "missing.txt"
      ]
      store = Store.new(lines, :file_filter => "abc|efg")
      store.to_s.must_equal "abc.txt,3\nefg.txt,2\nabc.log,1\n"
    end
  end
end
