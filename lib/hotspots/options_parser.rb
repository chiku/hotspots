require 'optparse'

module Hotspots
  class OptionsParser
    def initialize
      @options = {
        :time => 15,
        :repository => ".",
        :file_filter => "",
        :filter => "",
        :message_filter => "",
        :cutoff => 0
      }
    end

    def parse
      parser = new_option_parser
      begin
        parser.parse!
      rescue OptionParser::InvalidOption => ex
        puts ex.to_s
        puts "Use -h for help\n"
        exit 1
      end
      @options
    end

    private

    def new_option_parser
      OptionParser.new do |opts|
        set_banner_on(opts)

        handle_time_on(opts)
        handle_path_on(opts)
        handle_file_filter_on(opts)
        handle_message_filter_on(opts)
        handle_cutoff_on(opts)

        handle_help_on(opts)
      end
    end

    def set_banner_on(opts)
      opts.banner = "Tool to find most modified files over the past in a git repository."

      opts.separator ""
      opts.separator "Usage: ruby #{__FILE__} [options]"
      opts.separator ""
      opts.separator "Specific options:"
    end

    def handle_time_on(opts)
      opts.on("-t", "--time [TIME]", OptionParser::DecimalInteger,
              "Time in days to scan the repository for. Defaults to fifteen") do |o|
        @options[:time] = o
      end
    end

    def handle_path_on(opts)
      opts.on("-r", "--repository [PATH]", String,
              "Path to the repository to scan. Defaults to current path") do |o|
        @options[:repository] = o
      end
    end

    def handle_file_filter_on(opts)
      opts.on("-f", "--file-filter [REGEX]", String,
              "Regular expression to filtering file names. All files are allowed when not specified") do |o|
        @options[:file_filter] = @options[:filter] = o
      end
    end

    def handle_message_filter_on(opts)
      opts.on("-m", "--message-filter [PIPE SEPARATED]", String,
              "Pipe separated values to filter files names against each commit message separated by pipe. All files are allowed when not specified") do |o|
        @options[:message_filter] = o
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
end
