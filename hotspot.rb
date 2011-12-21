require 'optparse'

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

class HotspotOptionsParser
  def initialize
    @options = {
      :time => 15,
      :repository => ".",
      :filter => "",
      :cutoff => 0
    }
  end

  def parse
    @parsed ||= OptionParser.new do |opts|
      set_banner_on(opts)

      handle_time_on(opts)
      handle_path_on(opts)
      handle_filter_on(opts)
      handle_cutoff_on(opts)

      handle_help_on(opts)
    end.parse!

    @options
  end

  private

  def set_banner_on(opts)
    opts.banner = "Tool to find most modified files over the past in a git repository."

    opts.separator ""
    opts.separator "Usage: ruby #{__FILE__} [options]"
    opts.separator ""
    opts.separator "Specific options:"
  end

  def handle_time_on(opts)
    opts.on("-t", "--time [TIME]", OptionParser::DecimalInteger,
            "Time is days to scan the repository for. Defaults to fifteen") do |o|
      @options[:time] = o
    end
  end

  def handle_path_on(opts)
    opts.on("-r", "--repository [PATH]", String,
            "The path to the current repository. Defaults to current path") do |o|
      @options[:repository] = o
    end
  end

  def handle_filter_on(opts)
    opts.on("-f", "--filter [REGEX]", String,
            "The regular expression for file to filter with. All files are allowed when not specified") do |o|
      @options[:filter] = o
    end
  end

  def handle_cutoff_on(opts)
    opts.on("-c", "--cutoff [CUTOFF]", OptionParser::DecimalInteger,
            "The minimum occurance to consider for a file to appear in the list. Defaults to zero") do |o|
      @options[:cutoff] = o.to_i
    end
  end

  def handle_help_on(opts)
    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end
  end
end

if __FILE__ == $0
  options = HotspotOptionsParser.new.parse

  files = %x(
    cd #{options[:repository]} && \
    git log --pretty="%H" --since #{options[:time]}.days.ago |
    while read commit_hash
    do
      git show --oneline --name-only $commit_hash | tail -n+2 | grep "#{options[:filter]}"
    done &&
    cd -
  ).to_s.split("\n")

  puts Hotspot.new(files, options[:cutoff]).to_s
end
