class Hotspot
  def initialize(lines, cutoff=0)
    @lines  = lines
    @store  = Hash.new(0)
    @cutoff = cutoff

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
      dump << "#{key},#{value}\n" if value >= @cutoff
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
  usage = "ruby #{__FILE__} <Search pattern to include> [Path to repository] [Min. cutoff for occurance] [Time in days]"

  if ["-h", "--help"].include? ARGV[0]
    puts usage
    exit 0
  end

  inclusions = ARGV[0].to_s
  path       = ARGV[1]      || "."
  cutoff     = ARGV[2].to_i
  time       = ARGV[3]      || 15

  if inclusions.empty?
    puts usage
    exit 1
  end

  files = `cd #{path} && git log --name-only --since #{time}.days.ago | grep #{inclusions} && cd -`.split("\n")
  puts Hotspot.new(files, cutoff).to_s
end
