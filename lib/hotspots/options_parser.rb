require 'optparse'

require 'hotspots/version'
require 'hotspots/option_based_exit'

class Hotspots
  class OptionsParser #:nodoc: all
    class << self
      def default_options
        {
          :time            => 15,
          :repository      => ".",
          :file_filter     => "",
          :message_filters => [""],
          :cutoff          => 0,
          :log_level       => :error,
          :exit_strategy   => OptionBasedExit::Noop.new,
          :colour          => false,
        }
      end
    end

    def initialize
      @options = self.class.default_options
    end

    def parse(*args)
      parser = new_option_parser
      begin
        parser.parse args
      rescue ::OptionParser::InvalidOption, ::OptionParser::InvalidArgument => ex
        @options[:exit_strategy] = OptionBasedExit::Error.new(:code => 1, :message => (ex.to_s << "\nUse -h for help\n"))
      end
      @options
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
        handle_log_level_on(opts)
        handle_verbosity_on(opts)
        handle_colours_on(opts)
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
      opts.separator "Usage: ruby hotspots [options]"
      opts.separator ""
      opts.separator "Specific options:"
    end

    def handle_time_on(opts)
      opts.on("-t", "--time [TIME]", OptionParser::DecimalInteger,
              "Time in days to scan the repository for. Defaults to fifteen") do |o|
        @options[:time] = o.to_i
      end
    end

    def handle_path_on(opts)
      opts.on("-r", "--repository [PATH]", String,
              "Path to the repository to scan. Defaults to current path") do |o|
        @options[:repository] = o.to_s
      end
    end

    def handle_file_filter_on(opts)
      opts.on("-f", "--file-filter [REGEX]", String,
              "Regular expression to filtering file names.",
              "All files are allowed when not specified") do |o|
        @options[:file_filter] = o.to_s
      end
    end

    def handle_message_filter_on(opts)
      opts.on("-m", "--message-filter [PIPE SEPARATED]", String,
              "Pipe separated values to filter files names against each commit message.",
              "All files are allowed when not specified") do |o|
        @options[:message_filters] = o.to_s.split("|")
      end
    end

    def handle_cutoff_on(opts)
      opts.on("-c", "--cutoff [CUTOFF]", OptionParser::DecimalInteger,
              "The minimum occurance to consider for a file to appear in the list. Defaults to zero") do |o|
        @options[:cutoff] = o.to_i
      end
    end

    def handle_log_level_on(opts)
      allowed_levels = [:debug, :info, :warn, :error, :fatal]
      opts.on("--log [LOG LEVEL]", allowed_levels,
              "Log level (#{allowed_levels.join(", ")})") do |o|
        @options[:log_level] = o
      end
    end

    def handle_verbosity_on(opts)
      opts.on("-v", "--verbose",
              "Show verbose output") do
        @options[:log_level] = :debug
      end
    end

    def handle_colours_on(opts)
      opts.on("-C", "--colour", "--color",
              "Show output in colours. The log level should be info or debug for colours") do
        @options[:colour] = true
      end
    end

    def handle_help_on(opts)
      opts.on_tail("-h", "--help",
                   "Show this message") do
        @options[:exit_strategy] = OptionBasedExit::Safe.new(:message => opts.to_s)
      end
    end
  end
end
