class Hotspot
  def initialize(lines)
    @lines = lines
    @store = Hash.new(0)

    @lines.map   { |line| line.strip.downcase }
          .select{ |line| not line.empty? }
          .each  { |line| @store[line] += 1 }
  end

  def on(line)
    @store[line]
  end

  def to_s
    dump = ""
    sorted_array.each do |key, value|
      dump << "#{key},#{value}\n"
    end

    dump
  end

  private

  def sorted_array
    @store.sort do |(key1, value1), (key2, value2)|
      value2 <=> value1
    end
  end
end
