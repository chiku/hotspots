require 'hotspots/version'
require 'hotspots/logger'
require 'hotspots/store'
require 'hotspots/options_parser'
require 'hotspots/repository'

module Hotspots
  class Main
    attr_reader :logger, :repository, :verbose, :colour,
                :exit_strategy, :driver, :parser, :store,
                :time, :message_filters, :file_filter, :cutoff

    def initialize(opts)
      options          = Hotspots::OptionsParser.default_options.merge(opts)

      @logger          = Hotspots::Logger.new
      @repository      = options[:repository]
      @verbose         = options[:verbose]
      @colour          = options[:colour]
      @exit_strategy   = options[:exit_strategy]

      @time            = options[:time]
      @message_filters = options[:message_filters]
      @file_filter     = options[:file_filter]
      @cutoff          = options[:cutoff]
    end

    def output
      validate
      set
      run
    end

    private

    def validate #:nodoc:
      exit_if_options_are_for_help
      exit_if_not_git_repository
    end

    def set #:nodoc:
      configure_logger
      set_path
      assign
    end

    def run #:nodoc:
      puts store.to_s
    end

    def exit_if_options_are_for_help
      exit_strategy.perform
    end

    def exit_if_not_git_repository
      output = `git status 2>&1`
      unless $? == 0
        puts "'#{repository}' doesn't seem to be a git repository!"
        exit 10
      end
    end

    def configure_logger
      if verbose
        logger.as_console
      end

      if colour
        logger.colourize
      end
    end

    def set_path
      Dir.chdir(repository)
    end

    def assign
      @driver  = Hotspots::Repository::Driver::Git.new logger
      @parser  = Hotspots::Repository::Parser::Git.new driver, :time => time, :message_filters => message_filters
      @store   = Hotspots::Store.new parser.files, :cutoff => cutoff, :file_filter => file_filter
    end
  end
end
