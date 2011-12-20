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
  require 'optparse'

  options = {
    :time => 15,
    :repository => ".",
    :filter => "",
    :cutoff => 0
  }

  OptionParser.new do |opts|
    opts.banner = "Tool to find most modified files over the past in a git repository."

    opts.separator ""
    opts.separator "Usage: ruby #{__FILE__} [options]"
    opts.separator ""
    opts.separator "Specific options:"

    opts.on("-t", "--time [TIME]", OptionParser::DecimalInteger,
            "Time is days to scan the repository for. Defaults to fifteen") do |o|
      options[:time] = o
    end

    opts.on("-r", "--repository [PATH]", String,
            "The path to the current repository. Defaults to current path") do |o|
      options[:repository] = o
    end

    opts.on("-f", "--filter [REGEX]", String,
            "The regular expression for file to filter with. All files are allowed when not specified") do |o|
      options[:filter] = o
    end

    opts.on("-c", "--cutoff [CUTOFF]", OptionParser::DecimalInteger,
            "The minimum occurance to consider for a file to appear in the list. Defaults to zero") do |o|
      options[:cutoff] = o.to_i
    end

    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end
  end.parse!

  files = %x(
    cd #{options[:repository]} && \
    git log --pretty="%H" --since #{options[:time]}.days.ago |
    while read commit_hash
    do
      git show --oneline --name-only $commit_hash | tail -n+2 | grep "#{options[:filter]}"
    done && \
    cd -
  ).to_s.split("\n")

  puts Hotspot.new(files, options[:cutoff]).to_s
end
