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

if __FILE__ == $0
  inclusions = ARGV[0]
  path       = ARGV[1]      || "."
  time       = ARGV[2]      || 15

  unless inclusions
    puts "ruby #{__FILE__} <Search pattern to include> [Path to repository] [Time in days]"
    exit 1
  end

  files = `cd #{path} && git log --name-only --since #{time}.days.ago | grep #{inclusions} && cd -`.split("\n")
  puts Hotspot.new(files).to_s
end
