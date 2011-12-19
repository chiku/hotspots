class Hotspot
  def initialize(lines)
    @lines = lines
    @store = {}

    @lines.each do |line|
      @store[line] = @store[line] ? @store[line] + 1 : 1
    end
  end

  def on(line)
    @store[line] ? @store[line] : 0
  end
end
