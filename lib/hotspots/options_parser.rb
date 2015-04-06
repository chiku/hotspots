require 'optparse'

require 'hotspots/version'
require 'hotspots/exit'

class Hotspots
  class OptionsParser #:nodoc: all
    def initialize(opts)
      @configuration = opts[:configuration].dup # TODO : Test that older options are not mutatated
    end

    def parse(*args)
      parser = new_option_parser
      begin
        parser.parse(args)
      rescue ::OptionParser::InvalidOption, ::OptionParser::InvalidArgument => ex
        @configuration.exit_strategy = Exit::Error.new(:code => 1, :message => (ex.to_s + "\nUse -h for help\n"))
      end
      @configuration
    end

    private

    def new_option_parser
      ::OptionParser.new do |opts|
        set_banner_on(opts)
        set_version_on(opts)

        handle_time_on(opts)
        handle_path_on(opts)
        handle_file_filter_on(opts)
        handle_message_filter_on(opts)
        handle_cutoff_on(opts)
        handle_verbosity_on(opts)
        handle_version_on(opts)
        handle_help_on(opts)
      end
    end

    def set_version_on(opts)
      opts.version = ::Hotspots::VERSION
    end

    def set_banner_on(opts)
      opts.banner = "Tool to find most modified files over the past few days in a git repository."

      opts.separator "Version #{::Hotspots::VERSION}"
      opts.separator "Copyright (C) 2011-2013 Chirantan Mitra"
      opts.separator ""
      opts.separator "Usage: hotspots [options]"
      opts.separator ""
      opts.separator "Specific options:"
    end

    def handle_time_on(opts)
      opts.on("-t", "--time [TIME]", OptionParser::DecimalInteger,
              "Time in days to scan the repository for. Defaults to fifteen") do |o|
        @configuration.time = o.to_i
      end
    end

    def handle_path_on(opts)
      opts.on("-r", "--repository [PATH]", String,
              "Path to the repository to scan. Defaults to current path") do |o|
        @configuration.repository = o.to_s
      end
    end

    def handle_file_filter_on(opts)
      opts.on("-f", "--file-filter [REGEX]", String,
              "Regular expression to filtering file names.",
              "All files are allowed when not specified") do |o|
        @configuration.file_filter = o.to_s
      end
    end

    def handle_message_filter_on(opts)
      opts.on("-m", "--message-filter [PIPE SEPARATED]", String,
              "Pipe separated values to filter files names against each commit message.",
              "All commit messages are allowed when not specified") do |o|
        @configuration.message_filters = o.to_s.split("|")
      end
    end

    def handle_cutoff_on(opts)
      opts.on("-c", "--cutoff [CUTOFF]", OptionParser::DecimalInteger,
              "The minimum occurrence to consider for a file to appear in the list. Defaults to zero") do |o|
        @configuration.cutoff = o.to_i
      end
    end

    def handle_verbosity_on(opts)
      opts.on("-v", "--verbose",
              "Show verbose output") do
        @configuration.log_level = :info
      end
    end

    def handle_version_on(opts)
      opts.on_tail("--version",
                   "Show version") do
        @configuration.exit_strategy = Exit::Safe.new(:message => "hotspots #{::Hotspots::VERSION}\n")
      end
    end

    def handle_help_on(opts)
      opts.on_tail("-h", "--help",
                   "Show this message") do
        @configuration.exit_strategy = Exit::Safe.new(:message => opts.to_s)
      end
    end
  end
end
